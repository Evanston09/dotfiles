import { readFile } from "node:fs/promises";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const FRESH_MODEL_MESSAGE = "__fresh_model_message__";
const FRESH_MODEL_ENTRY = "fresh-model-message";

export default function (pi: ExtensionAPI) {
  pi.on("input", async (event, ctx) => {
    if (
      event.source !== "extension" ||
      event.text !== FRESH_MODEL_MESSAGE
    ) {
      return;
    }

    const pendingEntry = [...ctx.sessionManager.getEntries()]
      .reverse()
      .find(
        (entry) =>
          entry.type === "custom" && entry.customType === FRESH_MODEL_ENTRY,
      );
    const pending = pendingEntry?.data as
      | { message: string; provider: string; modelId: string }
      | undefined;
    if (!pending) {
      ctx.ui.notify("Fresh model request is missing", "error");
      return { action: "handled" } as const;
    }

    const model = ctx.modelRegistry.find(pending.provider, pending.modelId);
    if (!model || !(await pi.setModel(model))) {
      ctx.ui.notify(
        `Model unavailable: ${pending.provider}/${pending.modelId}`,
        "error",
      );
      return { action: "handled" } as const;
    }

    return { action: "transform", text: pending.message } as const;
  });

  pi.registerCommand("fresh", {
    description: "Run the last assistant message in a fresh session; pass 'plan' and/or 'model'",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();

      const options = new Set(args.trim().split(/\s+/).filter(Boolean));
      if ([...options].some((option) => !["plan", "model"].includes(option))) {
        ctx.ui.notify("Usage: /fresh [model] [plan]", "warning");
        return;
      }

      const lastAssistantEntry = [...ctx.sessionManager.getBranch()]
        .reverse()
        .find(
          (entry) =>
            entry.type === "message" && entry.message.role === "assistant",
        );

      if (!lastAssistantEntry || lastAssistantEntry.type !== "message") {
        ctx.ui.notify("No previous assistant message found", "warning");
        return;
      }

      const previousMessage = lastAssistantEntry.message.content
        .filter((part) => part.type === "text")
        .map((part) => part.text)
        .join("\n");
      if (!previousMessage) {
        ctx.ui.notify("The previous assistant message contains no text", "warning");
        return;
      }

      let nextMessage = previousMessage;

      if (options.has("plan")) {
        const planPath = join(ctx.cwd, "PLAN.md");
        let plan: string;
        try {
          plan = await readFile(planPath, "utf8");
        } catch {
          ctx.ui.notify(`Cannot read ${planPath}`, "error");
          return;
        }

        const planContext = `PLAN.md:\n\n${plan}\n\nPrevious request:\n\n`;
        nextMessage = `${planContext}${previousMessage}`;
      }

      if (options.has("model")) {
        const availableModels = ctx.modelRegistry.getAvailable();
        const availableIds = new Set(
          availableModels.map((model) => `${model.provider}/${model.id}`),
        );
        const models =
          ctx.scopedModels.length > 0
            ? ctx.scopedModels
                .map(({ model }) => model)
                .filter((model) =>
                  availableIds.has(`${model.provider}/${model.id}`),
                )
            : availableModels;

        if (models.length === 0) {
          ctx.ui.notify("No models are available", "warning");
          return;
        }

        const modelByLabel = new Map(
          models.map((model) => [
            `${model.provider}/${model.id}`,
            model,
          ]),
        );
        const selection = await ctx.ui.select(
          "Select model for the fresh session:",
          [...modelByLabel.keys()],
        );
        if (!selection) {
          return;
        }

        const model = modelByLabel.get(selection)!;
        await ctx.newSession({
          setup: async (sessionManager) => {
            sessionManager.appendCustomEntry(FRESH_MODEL_ENTRY, {
              message: nextMessage,
              provider: model.provider,
              modelId: model.id,
            });
          },
          withSession: async (replacementCtx) => {
            await replacementCtx.sendUserMessage(FRESH_MODEL_MESSAGE);
          },
        });
        return;
      }

      await ctx.newSession({
        withSession: async (replacementCtx) => {
          await replacementCtx.sendUserMessage(nextMessage);
        },
      });
    },
  });
}
