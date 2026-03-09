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

These tasks could be something like:
- Put each colored egg in their respective colored basket
- Catch the fruits before they hit the ground, avoiding other elements
- Pull the vegetables from the ground

We created the loop for the scenes, including saving the states for the minigames while returning to the map.

[!(Game Scene Loop)](https://github.com/user-attachments/assets/f886d58f-ab2b-45d3-b484-0d100769ebfb)

### Day 2

Today, 2 goals were proposed:
- Player movement on map and enter into minigames
- Checklist of minigames that were done

The movement of the player was quite easy to do. Just handle the mouse input and set a vector for it to move automatically using the `move_and_slide` function from `CharacterBody2D` set as floating body.

For the checklist, we created a new class that use an array of `CheckBox` and set the input handling to ignore, so the player can't interact with it.

Here is a video about today's progress:

[!(Player movement)](https://github.com/user-attachments/assets/1e0092f0-a51a-4d5b-92d5-954a8e3409b9)

### Day 3

Today we started to introduce art elements, like images, music and sound effects.
For some elements, we used free usage pictures that we found on the net until we can replace them.

For programming, we have these goals:
- Make some followers for the main map
- Start creating the first minigame

For making the followers, we created a new class that takes the leader position and applies several calculations to follow. It's actually very similar to the movement of the player (which is the leader), but taking into account some separation between the followers.

The first minigame will be getting the right eggs into the right basket. There will be some chickens that runs in the map and from time to time a egg will appears. The egg will have some color and the player has to drag and drop it to the correct colored basket.

We could not finish programming the minigame today, but it's almost done.

Here is a video about today's progress:

[![Day 3 progress](https://img.youtube.com/vi/fn-RazAVM5E/0.jpg)](https://www.youtube.com/watch?v=fn-RazAVM5E)

## Tools used
- Godot 4.6
- vscodium
- Albleton
- Bitwig

## Credits

### From [Artepodrez](https://www.pexels.com/es-es/@artempodrez/)
[Blue background](https://www.pexels.com/es-es/foto/arte-creativo-espacio-azul-7232658/)

[Green background](https://www.pexels.com/es-es/foto/textura-abstracto-resumen-verde-7233124/)
