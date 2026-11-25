import csv
import argparse
from pathlib import Path

RAW_DIR = Path("data/raw")

TICKETS_FILE = RAW_DIR / "tickets.csv"
EVENTS_FILE = RAW_DIR / "ticket_events.csv"


def read_csv(path):
    with path.open("r", newline="", encoding="utf-8-sig") as file:
        reader = csv.DictReader(file)
        return reader.fieldnames, list(reader)


def write_csv(path, fieldnames, rows):
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def add_new_ticket():
    fields, rows = read_csv(TICKETS_FILE)

    new_ticket = {
        "ticket_id": "T999998",
        "customer_id": "C00996",
        "created_at": "2026-11-25 09:00:00",
        "issue_category": "account_access",
        "channel": "chat",
        "priority": "medium",
        "assigned_agent_id": "A010",
        "source_system": "helpdesk",
    }

    if any(r["ticket_id"] == new_ticket["ticket_id"] for r in rows):
        print("Test ticket already exists.")
        return

    rows.append(new_ticket)
    write_csv(TICKETS_FILE, fields, rows)

    print("Added new ticket T999999")


def update_existing_ticket():
    fields, rows = read_csv(TICKETS_FILE)

    for row in rows:
        if row["ticket_id"] == "T000001":
            row["priority"] = "high"
            write_csv(TICKETS_FILE, fields, rows)
            print("Updated T000001 priority to high")
            return

    raise ValueError("Test ticket not found")


def add_event(event):
    fields, rows = read_csv(EVENTS_FILE)

    if any(r["event_id"] == event["event_id"] for r in rows):
        print("Test event already exists.")
        return

    rows.append(event)
    write_csv(EVENTS_FILE, fields, rows)

    print(f"Added event {event['event_id']}")


def add_new_event():

    add_event({
        "event_id": "E9999993",
        "ticket_id": "T999998",
        "event_timestamp": "2026-11-25 09:00:00",
        "event_type": "created",
        "actor_type": "customer",
        "ingested_at": "2026-11-25 09:00:00",
    })

    add_event({
        "event_id": "E9999991",
        "ticket_id": "T999998",
        "event_timestamp": "2026-11-25 09:30:00",
        "event_type": "agent_first_response",
        "actor_type": "agent",
        "ingested_at": "2026-11-25 09:35:00",
    })


def add_late_event():
    add_event({
        "event_id": "E9999992",
        "ticket_id": "T000001",
        "event_timestamp": "2026-08-04 19:00:00",
        "event_type": "agent_first_response",
        "actor_type": "agent",
        "ingested_at": "2026-11-25 10:00:00",
    })


SCENARIOS = {
    "new_ticket": add_new_ticket,
    "update_ticket": update_existing_ticket,
    "new_event": add_new_event,
    "late_event": add_late_event,
}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "scenario",
        choices=SCENARIOS.keys()
    )

    args = parser.parse_args()

    SCENARIOS[args.scenario]()