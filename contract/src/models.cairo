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

#[derive(Model, Copy, Drop, Serde)]
struct Corner {
    #[key]
    game_id: felt252,
    #[key]
    x: u8,
    #[key]
    y: u8,
    settlement: ContractAddress,
    road: ContractAddress,
    city: ContractAddress,
}


#[derive(Model, Copy, Drop, Serde)]
struct Resource {
    #[key]
    game_id: felt252,
    #[key]
    player: ContractAddress,
    wood: u8,
    brick: u8,
    sheep: u8,
    wheat: u8,
    stone: u8,
    point: u8,
}
