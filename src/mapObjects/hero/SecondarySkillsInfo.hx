package mapObjects.hero;

class SecondarySkillsInfo {
    //skills are determined, initialized at map start
    public var magicSchoolCounter:Int;
    public var wisdomCounter:Int;

    public function new() {
        magicSchoolCounter = 1;
        wisdomCounter = 1;
    }

    public function resetWisdomCounter() {
        wisdomCounter = 1;
    }

    public function resetMagicSchoolCounter() {
        magicSchoolCounter = 1;
    }
}