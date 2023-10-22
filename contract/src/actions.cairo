use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo_examples::models::{Game, Hexagon, Land};
use starknet::{ContractAddress, ClassHash, get_block_hash_syscall, get_block_info};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn init(self: @TContractState, player2: ContractAddress, player3: ContractAddress);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use core::traits::Into;
    use core::clone::Clone;
    use core::starknet::SyscallResultTrait;
    use core::result::ResultTrait;
    use core::traits::Destruct;
    use starknet::{ContractAddress, get_caller_address, get_block_hash_syscall, get_block_info};
    use dojo_examples::models::{Position, Hexagon, Land, Game};
    use dojo_examples::utils::get_hexagon_init;
    use debug::PrintTrait;
    use super::IActions;

    // // declaring custom event struct
    // #[event]
    // #[derive(Drop, starknet::Event)]
    // enum Event {
    //     Moved: Moved,
    // }

    // // declaring custom event struct
    // #[derive(Drop, starknet::Event)]
    // struct Moved {
    //     player: ContractAddress,
    //     direction: Direction
    // }

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn init(self: @ContractState, player2: ContractAddress, player3: ContractAddress) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let player1 = get_caller_address();

            // generate 3 player game id by pedersen hash
            let game_id = pedersen::pedersen(
                pedersen::pedersen(player1.into(), player2.into()), player3.into()
            );
            let block_number = get_block_info().unbox().block_number;

            let block_hash = get_block_hash_syscall(block_number - 10).unwrap_syscall();
            // let block_hash: felt252 = "HELLO BTAVE WORLD";
            let hex1: Hexagon = get_hexagon_init(1, block_hash.clone(), game_id);
            let hex1 = get_hexagon_init(1, block_hash.clone(), game_id);
            let hex2 = get_hexagon_init(2, block_hash.clone(), game_id);
            let hex3 = get_hexagon_init(3, block_hash.clone(), game_id);
            let hex4 = get_hexagon_init(4, block_hash.clone(), game_id);
            let hex5 = get_hexagon_init(5, block_hash.clone(), game_id);
            let hex6 = get_hexagon_init(6, block_hash.clone(), game_id);
            let hex7 = get_hexagon_init(7, block_hash.clone(), game_id);
            let hex8 = get_hexagon_init(8, block_hash.clone(), game_id);
            let hex9 = get_hexagon_init(9, block_hash.clone(), game_id);
            let hex10 = get_hexagon_init(10, block_hash.clone(), game_id);
            let hex11 = get_hexagon_init(11, block_hash.clone(), game_id);
            let hex12 = get_hexagon_init(12, block_hash.clone(), game_id);
            let hex13 = get_hexagon_init(13, block_hash.clone(), game_id);
            let hex14 = get_hexagon_init(14, block_hash.clone(), game_id);
            let hex15 = get_hexagon_init(15, block_hash.clone(), game_id);
            let hex16 = get_hexagon_init(16, block_hash.clone(), game_id);
            let hex17 = get_hexagon_init(17, block_hash.clone(), game_id);
            let hex18 = get_hexagon_init(18, block_hash.clone(), game_id);
            let hex19 = get_hexagon_init(19, block_hash.clone(), game_id);

            set!(
                world,
                (
                    Game { game_id, player1, player2, player3, turn: 1 },
                    hex1,
                    hex2,
                    hex3,
                    hex4,
                    hex5,
                    hex6,
                    hex7,
                    hex8,
                    hex9,
                    hex10,
                    hex11,
                    hex12,
                    hex13,
                    hex14,
                    hex15,
                    hex16,
                    hex17,
                    hex18,
                    hex19
                )
            );
        }
    // // Implementation of the move function for the ContractState struct.
    // fn move(self: @ContractState, direction: Direction) {
    //     // Access the world dispatcher for reading.
    //     let world = self.world_dispatcher.read();

    //     // Get the address of the current caller, possibly the player's address.
    //     let player = get_caller_address();

    //     // Retrieve the player's current position and moves data from the world.
    //     let (mut position, mut moves) = get!(world, player, (Position, Moves));

    //     // Deduct one from the player's remaining moves.
    //     moves.remaining -= 1;

    //     // Update the last direction the player moved in.
    //     moves.last_direction = direction;

    //     // Calculate the player's next position based on the provided direction.
    //     let next = next_position(position, direction);

    //     // Update the world state with the new moves data and position.
    //     set!(world, (moves, next));

    //     // Emit an event to the world to notify about the player's move.
    //     emit!(world, Moved { player, direction });
    // }
    }
}
#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // import models
    use dojo_examples::models::{hexagon, game};
    use dojo_examples::models::{Hexagon, Land, Game};

    // import actions
    use super::{actions, IActionsDispatcher, IActionsDispatcherTrait};

    #[test]
    #[available_gas(30000000)]
    fn test_move() {
        // caller
        let caller = starknet::contract_address_const::<0x0>();
        let player2 = starknet::contract_address_const::<0x1>();
        let player3 = starknet::contract_address_const::<0x2>();

        // models
        let mut models = array![hexagon::TEST_CLASS_HASH, game::TEST_CLASS_HASH];
        // deploy world with models
        let world = spawn_test_world(models);
        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
        let actions_system = IActionsDispatcher { contract_address };
        // call spawn()
        actions_system.init(player2, player3);
        let game_id = pedersen::pedersen(
            pedersen::pedersen(caller.into(), player2.into()), player3.into()
        );
        // Check world state
        let hex1 = get!(world, (game_id, 1), Hexagon);
        // hex1.land.print();
        assert(hex1.dice_roll == 5, 'dice is wrong');
        assert(hex1.game_id == game_id, 'game_id is wrong');
        assert(hex1.hexagon_id == 1, 'hexagon_id is wrong');
    }
}

