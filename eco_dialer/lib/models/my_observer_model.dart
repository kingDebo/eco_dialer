enum ObserverTag { time, color }

mixin MyObservable {
  List<MyObserver> timeObservers = [];
  List<MyObserver> colorObservers = [];

  void addObserver(dynamic observer, ObserverTag tag);

  void removeObserver(dynamic observer);

  void notifyAllTime();
  void notifyAllColor();
}

abstract class MyObserver {
  void update({dynamic updatedInfo});
}
