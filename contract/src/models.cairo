use array::ArrayTrait;
use core::debug::PrintTrait;
use starknet::ContractAddress;
use dojo::database::schema::{
    Enum, Member, Ty, Struct, SchemaIntrospection, serialize_member, serialize_member_type
};

#[derive(Serde, Copy, Drop, Introspect)]
enum Land {
    Hill: (),
    Forest: (),
    Mountain: (),
    Pasture: (),
    Field: (),
    Desert: (),
}

impl LandPrintImpl of PrintTrait<Land> {
    fn print(self: Land) {
        match self {
            Land::Hill(()) => 'hill'.print(),
            Land::Forest(()) => 'forest'.print(),
            Land::Mountain(()) => 'moutain'.print(),
            Land::Pasture(()) => 'pasture'.print(),
            Land::Field(()) => 'field'.print(),
            Land::Desert(()) => 'desert'.print(),
        }
    }
}

impl LandIntoFelt252 of Into<Land, felt252> {
    fn into(self: Land) -> felt252 {
        match self {
            Land::Hill(()) => 0,
            Land::Forest(()) => 1,
            Land::Mountain(()) => 2,
            Land::Pasture(()) => 3,
            Land::Field(()) => 4,
            Land::Desert(()) => 5,
        }
    }
}

#[derive(Model, Copy, Drop, Serde)]
struct Game {
    #[key]
    game_id: felt252,
    player1: ContractAddress,
    player2: ContractAddress,
    player3: ContractAddress,
    turn: u8,
}

#[derive(Model, Copy, Drop, Serde)]
struct Hexagon {
    #[key]
    game_id: felt252,
    #[key]
    hexagon_id: u8,
    dice_roll: u8,
    land: Land,
}

#[derive(Copy, Drop, Serde, Print, Introspect)]
struct Vec2 {
    x: u32,
    y: u32
}

#[derive(Model, Copy, Drop, Print, Serde)]
struct Position {
    #[key]
    player: ContractAddress,
    vec: Vec2,
}

trait Vec2Trait {
    fn is_zero(self: Vec2) -> bool;
    fn is_equal(self: Vec2, b: Vec2) -> bool;
}

impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        if self.x - self.y == 0 {
            return true;
        }
        false
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
}

#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use super::{Position, Vec2, Vec2Trait};

    #[test]
    #[available_gas(100000)]
    fn test_vec_is_zero() {
        assert(Vec2Trait::is_zero(Vec2 { x: 0, y: 0 }), 'not zero');
    }

    #[test]
    #[available_gas(100000)]
    fn test_vec_is_equal() {
        let position = Vec2 { x: 420, y: 0 };
        assert(position.is_equal(Vec2 { x: 420, y: 0 }), 'not equal');
    }
}
