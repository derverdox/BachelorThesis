pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract VirtualPet is ERC721 {
    uint256 private _tokenIds; bool existAny;
    enum PetSize{VERY_SMALL, SMALL, MEDIUM, LARGE, HUGE}
    enum Personality{Brave, Shy, Curious, Loyal, Playful}
    enum Elemental_Type{Fire, Water, Earth, Air, Lightning}
    enum Race{Dragon, Unicorn, Phoenix, Turtle, MagicRabbit}
    enum AttackType{Melee, Ranged, Magic, Poison, Curse}
    enum FoodPreferences{Carnivore, Herbivore, Omnivore, Magic_eating, Not_eating}

    struct PetProperties{ uint256 date_of_birth; Race race; Elemental_Type elementary_type; PetSize pet_size; Personality personality; AttackType attackt_type; FoodPreferences food_preferences;}

    mapping(uint256 tokenId => PetProperties) private petIdToPropertyMapping;

    constructor() ERC721("VirtualPet", "VP"){}

    function createNewPet() public returns (uint256 petID){
        _tokenIds++;
        _mint(msg.sender, _tokenIds);
        existAny = true;

        uint256 date_of_birth = block.timestamp;
        (Race race,
        Elemental_Type elemental_type,
        PetSize pet_size,
        Personality personality,
        AttackType attack_type,
        FoodPreferences food_preferences) = drawRandomPetProperties();
        petIdToPropertyMapping[_tokenIds] = PetProperties(date_of_birth, race, elemental_type, pet_size, personality, attack_type, food_preferences);
        return _tokenIds;
    }



    function getProperties(uint256 petId) public view returns (PetProperties memory){
        require(existAny && petId <= _tokenIds, "A pet with this id does not exist.");
        return petIdToPropertyMapping[petId];
    }

    // ### RandomProperties

    function drawRandomPetProperties () public view returns(
        Race race, Elemental_Type elemental_type,
        PetSize pet_size, Personality personality,
        AttackType attack_type, FoodPreferences food_preferences){

        race = Race(randomNumber(10) % uint256(Race.MagicRabbit) + 1);
        elemental_type = Elemental_Type(randomNumber(11) % uint256(Elemental_Type.Lightning) + 1);
        pet_size = drawRandomPetSize();
        personality = Personality(randomNumber(15) % uint256(Personality.Playful) + 1);
        attack_type = AttackType(randomNumber(20) % uint256(AttackType.Curse) + 1);
        food_preferences = FoodPreferences(randomNumber(4) % uint256(FoodPreferences.Magic_eating) + 1);
    }

    function drawRandomPetSize () private view returns (PetSize){
        uint256 percentage = randomNumber();
        if(percentage < 1)
            return PetSize.HUGE;
        else if(percentage < 5)
            return PetSize.LARGE;
        else if(percentage < 15)
            return PetSize.MEDIUM;
        else if(percentage < 45)
            return PetSize.SMALL;
        else return PetSize.VERY_SMALL;
    }


    // #### Random Number Functions ###
    function randomNumber (uint256 seed) public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, msg.data, seed)));
    }
    function randomPercentage (uint256 seed) public view returns (uint){
        return randomNumber(seed) % 100;
    }
    function randomPercentage () external view returns (uint){ return randomPercentage(0); }
    function randomNumber () public view returns (uint) { return randomNumber(0); }
    // ## Helper function 
    function getLastTokenID() public view returns(uint256){
        return _tokenIds;
    }
}
