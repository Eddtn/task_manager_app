enum Priority { low, medium, high }

String priorityLabel(Priority p) {
  switch (p) {
    case Priority.low:
      return "Low";
    case Priority.medium:
      return "Medium";
    case Priority.high:
      return "High";
  }
}

int priorityRank(Priority p) {
  switch (p) {
    case Priority.low:
      return 0;
    case Priority.medium:
      return 1;
    case Priority.high:
      return 2;
  }
}
