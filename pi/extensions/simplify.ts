import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("simplify", {
    description: "Start a fresh session and run ponytail-review",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();

      const parentSession = ctx.sessionManager.getSessionFile();
      const trimmedArgs = args.trim();
      const skillCommand = `/skill:ponytail-review${trimmedArgs ? ` ${trimmedArgs}` : ""}`;

      const result = await ctx.newSession({
        parentSession,
        withSession: async (replacementCtx) => {
          await replacementCtx.sendUserMessage(skillCommand, {
            expandPromptTemplates: true,
          });
        },
      });

      if (result.cancelled) {
        ctx.ui.notify("New session cancelled", "info");
      }
    },
  });
}
