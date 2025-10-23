#!/usr/bin/env python3

import json
from datetime import datetime
from pathlib import Path

def main():
    script_dir = Path(__file__).parent
    with open(script_dir / "times.json", "r") as file:
        schedule = json.load(file)
    
    now = datetime.now()
    todays_schedule = schedule.get(str(now.weekday()), [])
    
    next_class = None
    time_until_next = None
    
    for times in todays_schedule:
        start = datetime.strptime(times['startTime'], "%H:%M")
        # Fix: need to give start a date component to compare properly
        start = now.replace(hour=start.hour, minute=start.minute, second=0, microsecond=0)
        
        if start > now:
            next_class = times['class']
            time_until_next = start - now
            break
    
    if time_until_next and next_class:
        hours_left = time_until_next.seconds // 3600
        minutes_left = (time_until_next.seconds // 60) % 60
        
        output = {
            "text": f"{next_class} in {hours_left}:{minutes_left:02d}",
            "tooltip": f"Next class: {next_class}",
            "class": "has-next-class"
        }
    else:
        output = {
            "text": "No more classes today 🎉",
            "tooltip": "Enjoy your free time!",
            "class": "no-next-class"
        }
    
    print(json.dumps(output))

if __name__ == "__main__":
    main()
