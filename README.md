# Fairies Helper Initiative

Fairies Helper Initiative is a game made for the game jam [Girly Game Jam](https://itch.io/jam/-girly-game-jam-3-1).

The goal fo the jam is to make a game that resemble the quirkiness of girly games in early 2000s.

The theme is `The small Things`.

The participants are:
- [Ouro17](https://ouro17.itch.io/) as Programmer
- [HAQ1](https://soundcloud.com/haq1): Sound and music, art
- Paula: Art

## The process

### Day 1

We joined to braimstorm the game for 2 hours. We researched girly games and we reached the conclusion that
girly games have a lot of mini-games. Doing many mini-games can be tricky because the limited time, but
we agreed to do one at a time so the ones that we have are complete.

The small Things are the fairies, that will help the little girl to fulfill a series of tasks.

We created the loop for the scenes, including saving the states for the minigames while returning to the map.

[!(Game Scene Loop)](https://github.com/user-attachments/assets/f886d58f-ab2b-45d3-b484-0d100769ebfb)


### Day 2

Today, 2 goals were proposed:
- Player movement on map and enter into minigames
- Checklist of minigames that were done

The movement of the player was quite easy to do. Just handle the mouse input and set a vector for it to move automatically using the `move_and_slide` function from `CharacterBody2D` set as floating body.

For the checklist, we created a new class that use an array of `CheckBox` and set the input handling to ignore, so the player can't interact with it.

## Tools used
- Godot 4.6
- vscodium
- Albleton
- Bitwig
