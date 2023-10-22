use dojo_examples::models::{Hexagon, Land};
use debug::PrintTrait;
// 19 hexagon have fixed dice roll value [5, 2, 6, 3, 8, 10, 9, 12 , 11, 4, 8, 10, 9, 4, 5, 6, 3, 11]
fn get_hexagon_init(hexagon_id: u8, block_hash: felt252, game_id: felt252) -> Hexagon {
    let mut dice_roll = 0;
    let a = array![0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4];
    let shuffed_a = shuffle_array(a, block_hash);
    //shuffed_a.len().print();
    //let shuffed_a = array![0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3];

    if (hexagon_id == 1) {
        dice_roll = 5;
        'ohayo'.print();
    } else if (hexagon_id == 2) {
        dice_roll = 2;
    } else if (hexagon_id == 3) {
        dice_roll = 6;
    } else if (hexagon_id == 4) {
        dice_roll = 3;
    } else if (hexagon_id == 5) {
        dice_roll = 8;
    } else if (hexagon_id == 6) {
        dice_roll = 10;
    } else if (hexagon_id == 7) {
        dice_roll = 9;
    } else if (hexagon_id == 8) {
        dice_roll = 12;
    } else if (hexagon_id == 9) {
        dice_roll = 11;
    } else if (hexagon_id == 10) {
        dice_roll = 4;
    } else if (hexagon_id == 11) {
        dice_roll = 8;
    } else if (hexagon_id == 12) {
        dice_roll = 10;
    } else if (hexagon_id == 13) {
        dice_roll = 9;
    } else if (hexagon_id == 14) {
        dice_roll = 4;
    } else if (hexagon_id == 15) {
        dice_roll = 5;
    } else if (hexagon_id == 16) {
        dice_roll = 6;
    } else if (hexagon_id == 17) {
        dice_roll = 3;
    } else if (hexagon_id == 18) {
        dice_roll = 11;
    } else {
        dice_roll = 0;
    }

    let mut land = Land::Desert(());
    if (hexagon_id != 19) {
        if (*shuffed_a.at(hexagon_id.into() - 1) == 0) {
            land = Land::Hill(());
        } else if (*shuffed_a.at(hexagon_id.into() - 1) == 1) {
            land = Land::Forest(());
        } else if (*shuffed_a.at(hexagon_id.into() - 1) == 2) {
            land = Land::Mountain(());
        } else if (*shuffed_a.at(hexagon_id.into() - 1) == 3) {
            land = Land::Field(());
        } else if (*shuffed_a.at(hexagon_id.into() - 1) == 4) {
            land = Land::Pasture(());
        }
    }
    dice_roll.print();
    return Hexagon { game_id: game_id, hexagon_id: hexagon_id, dice_roll: dice_roll, land };
}

// from Alexandria
fn pow(base: u128, exp: u128) -> u128 {
    if exp == 0 {
        1
    } else if exp == 1 {
        base
    } else if exp % 2 == 0 {
        pow(base * base, exp / 2)
    } else {
        base * pow(base * base, (exp - 1) / 2)
    }
}


fn concat(a: Span<u32>, b: Span<u32>) -> Array<u32> {
    // Can't do self.span().concat(a);
    let mut ret = array![];
    let mut i = 0;

    loop {
        if (i == a.len()) {
            break;
        }
        ret.append(*a[i]);
        i += 1;
    };
    i = 0;
    loop {
        if (i == b.len()) {
            break;
        }
        ret.append(*b[i]);
        i += 1;
    };
    ret
}

fn shuffle_array(a: Array<u32>, block_hash: felt252) -> Array<u32> {
    let mut a_copy: Array<u32> = a.clone();
    let mut shuffled_a: Array<u32> = array![];
    let mut block_hash_u128: u32 = block_hash.try_into().unwrap();

    let mut i = 0;
    loop {
        let len = a_copy.len();
        if len == 0 {
            break;
        };
        let element = block_hash_u128 % len;
        shuffled_a.append(*a_copy.at(element));

        if element + 1 != len {
            let back = a_copy.span().slice(element + 1, len - element - 1);
            let front = a_copy.span().slice(0, element);
            a_copy = concat(front, back);
        } else {
            let front = a_copy.span().slice(0, element);
            a_copy = concat(front, array![].span());
        }
        i += 1;
        block_hash_u128 = block_hash_u128 / len;
    };

    shuffled_a
}
