enum Incoterm {
  exw,
  fca,
  fas,
  fob,
  cfr,
  cif,
  cpt,
  cip,
  dap,
  dpu,
  ddp,
  unknown;

  static Incoterm fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'EXW':
        return Incoterm.exw;
      case 'FCA':
        return Incoterm.fca;
      case 'FAS':
        return Incoterm.fas;
      case 'FOB':
        return Incoterm.fob;
      case 'CFR':
        return Incoterm.cfr;
      case 'CIF':
        return Incoterm.cif;
      case 'CPT':
        return Incoterm.cpt;
      case 'CIP':
        return Incoterm.cip;
      case 'DAP':
        return Incoterm.dap;
      case 'DPU':
        return Incoterm.dpu;
      case 'DDP':
        return Incoterm.ddp;
      default:
        return Incoterm.unknown;
    }
  }

  String toJson() => name.toUpperCase(); // For potential saving back
}

// Enum for Status (add display names or colors if needed)
enum Status implements Comparable<Status> {
  completed(displayName: 'Completed', priority: 1),
  onhold(displayName: 'On Hold', priority: 2),
  ongoing(displayName: 'Ongoing', priority: 3),
  closefollowuprequired(displayName: 'Close Follow-up Required', priority: 4),
  critical(displayName: 'Critical', priority: 5);

  const Status({required this.displayName, required this.priority});

  final String displayName;
  final int priority;

  static Status fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'completed':
        return Status.completed;
      case 'ongoing':
        return Status.ongoing;
      case 'onhold':
        return Status.onhold;
      case 'closefollowuprequired':
        return Status.closefollowuprequired;
      case 'critical':
        return Status.critical;
      default:
        return Status.closefollowuprequired;
    }
  }

  String toJson() => name; // For potential saving back

  @override
  int compareTo(Status other) {
    return priority.compareTo(other.priority);
  }
}

