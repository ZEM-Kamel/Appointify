class MainLayoutState {
  final int currentIndex;

  const MainLayoutState({
    this.currentIndex = 0,
  });

  MainLayoutState copyWith({
    int? currentIndex,
  }) {
    return MainLayoutState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class MainLayoutInitial extends MainLayoutState {
  const MainLayoutInitial() : super(currentIndex: 0);
}

class MainLayoutChanged extends MainLayoutState {
  const MainLayoutChanged({required super.currentIndex});
} 