package mapObjects.pandorabox;

//event objects
class GEvent extends GPandoraBox {
    public var removeAfterVisit:Bool; //true if event is removed after occurring
    public var availableFor:Int; //players whom this event is available for
    public var computerActivate:Bool; //true if computer player can activate this event
    public var humanActivate:Bool; //true if human player can activate this event

    public function new() {
        super();
    }
}
