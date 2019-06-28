//
//  ViewController.swift
//  FinalProject
//
//  Created by Laird Connor Stephen Marlin I, Exquire on 6/18.
//  Copyright © 2019 Laird Connor Stephen Marlin I, Exquire. All rights reserved.
//

// Music: Eric Skiff - Song Name - Resistor Anthems - Available at http://EricSkiff.com/music

import UIKit
import AVFoundation

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

class ViewController: UIViewController {
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var staticHealthLabel: UILabel!
    @IBOutlet weak var enemyHealthLabel: UILabel!
    @IBOutlet weak var staticEnemyHealthLabel: UILabel!
    @IBOutlet weak var healButton: UIButton!
    
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var sneakButton: UIButton!
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var strengthButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var straightButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    
    var currentLevel = 0
    var currentRoom = 0.0
    var easterEggTracker = 0
    var currentHealth = 20
    var currentEnemyHealth = 0
    var eventResult = 0
    var inCombat = false
    var noticed = false
    var potionsCount = 5
    var helmetOn = true
    var gameOver = false
    
    var neutralBoss = false
    var genocideBoss = false
    var killCount = 0
    
    var enemies = Enemies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechButton.setTitle("Speech", for: .normal)
        eventLabel.text = ("Dungeon Delver")
        
        helpButton.isHidden = false
        
        healthLabel.isHidden = true
        staticHealthLabel.isHidden = true
        enemyHealthLabel.isHidden = true
        staticEnemyHealthLabel.isHidden = true
        healButton.isHidden = true
        healButton.setTitle("Heal(\(potionsCount))", for: .normal)
        
        leftButton.isHidden = true
        straightButton.isHidden = false
        rightButton.isHidden = true
        
        sneakButton.isHidden = true
        speechButton.isHidden = true
        strengthButton.isHidden = true
        
        helmetOn = true
        currentRoom = 0.0
        gameOver = false
        
        playSound(soundName: "ascending", audioPlayer: &audioPlayer)
        audioPlayer.numberOfLoops = -1
        
    }
    
    func playSound(soundName: String, audioPlayer: inout AVAudioPlayer) { //soundplaying func
        if let sound = NSDataAsset(name: soundName) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("ERROR: Data from \(soundName) could not be played as an audio file")
            }
        } else {
            print("ERROR: could not load data from file \(soundName)")
        }
    }
    
    func diceRoll() {
        let roll = Int.random(in: 1...10)
        let result = roll
        if result <= 3 {
            eventResult = 1
        } else if result >= 8 {
            eventResult = 3
        } else {
            eventResult = 2
        }
    }
    
    func sneakDiceRoll() {
        let roll = Int.random(in: 1...10)
        let result = roll
        if result == 1 {
            eventResult = 1
        } else if result >= 7 {
            eventResult = 3
        } else {
            eventResult = 2
        }
    }
    
    func strengthDiceRoll() {
        let roll = Int.random(in: 1...10)
        let result = roll
        if result <= 3 {
            eventResult = 1
        } else if result >= 8 {
            eventResult = 3
        } else {
            eventResult = 2
        }
    }
    
    func spellDiceRoll() {
        let roll = Int.random(in: 1...10)
        let result = roll
        if result <= 2 {
            eventResult = 1
        } else if result >= 4 {
            eventResult = 3
        } else {
            eventResult = 2
        }
    }
    
    func combatMode() {
        leftButton.isHidden = true
        straightButton.isHidden = true
        rightButton.isHidden = true
        sneakButton.isHidden = false
        speechButton.isHidden = false
        strengthButton.isHidden = false
        
        inCombat = true
        
        staticEnemyHealthLabel.isHidden = false
        enemyHealthLabel.isHidden = false
    }
    
    func exploreMode() {
        leftButton.isHidden = false
        straightButton.isHidden = false
        rightButton.isHidden = false
        sneakButton.isHidden = true
        speechButton.isHidden = true
        strengthButton.isHidden = true
        
        staticEnemyHealthLabel.isHidden = true
        enemyHealthLabel.isHidden = true
        inCombat = false
    }
    
    func foeDefeated() {
        eventLabel.text = "One final strike and your foe falls before you"
        enemyHealthLabel.text = "0"
        killCount += 1
        exploreMode()
    }
    
    func witchDefeated() {
        eventLabel.text = "One final strike and the witch explodes in a burst of light. In her wake lies a bundle of five healing potions. Huzzah!"
        potionsCount += 5
        healButton.setTitle("Heal(\(potionsCount))", for: .normal)
        killCount += 1
        enemyHealthLabel.text = "0"
        noticed = false
        exploreMode()
    }
    
    func finalBossDefeated() {
        enemyHealthLabel.text = "0"
        eventLabel.text = "With my death, this entire Dungeon falls apart, along with all of its treasure. Congratulations, you got the Genocide ending. Are you happy with that?"
        helpButton.setTitle("Restart", for: .normal)
        helpButton.isHidden = false
        speechButton.isHidden = true
        sneakButton.isHidden = true
        strengthButton.isHidden = true
        gameOver = true
    }
    
    func pacifistEnding() {
        eventLabel.text = "By now you know that I am the Dungeon Master. I built the walls of this crypt with my own fingers and summoned every 'foe' here to guard it. Yet you didn't kill a single one of them. Even when they harmed you, you took the pacifist's route. For all that clever work, you truly deserve the riches of my dungeon. I'll send you back out when you get all you can carry. Congratulations!"
        helpButton.setTitle("Finish", for: .normal)
        helpButton.isHidden = false
        leftButton.isHidden = true
        straightButton.isHidden = true
        rightButton.isHidden = true
        gameOver = true
    }
    
    func restart() {
        easterEggTracker = 0
        killCount = 0
        straightButton.setTitle("Forward", for: .normal)
        eventLabel.text = ("Dungeon Delver")
        
        helpButton.isHidden = false
        
        healthLabel.isHidden = true
        staticHealthLabel.isHidden = true
        enemyHealthLabel.isHidden = true
        staticEnemyHealthLabel.isHidden = true
        healButton.isHidden = true
        currentHealth = 20
        healthLabel.text = "\(currentHealth)"
        potionsCount = 5
        healButton.setTitle("Heal(\(potionsCount))", for: .normal)
        
        leftButton.isHidden = true
        straightButton.isHidden = false
        rightButton.isHidden = true
        
        sneakButton.isHidden = true
        speechButton.isHidden = true
        strengthButton.isHidden = true
        
        helmetOn = true
        currentRoom = 0.0
        gameOver = false
        
        enemies.goblinHealth = 5
        enemies.goblinIsAlive = true
        enemies.hobgoblinHealth = 7
        enemies.hobgoblinIsAlive = true
        enemies.warriorHealth = 8
        enemies.warriorIsAlive = true
        enemies.knightHealth = 25
        enemies.knightIsAlive = true
        enemies.ghostHealth = 1
        enemies.ghostIsAlive = true
        enemies.witchHealth = 10
        enemies.witchIsAlive = true
        enemies.bossHealth = 20
        enemies.bossIsAlive = true
        enemies.hardBossHealth = 1000
        enemies.hardBossIsAlive = true
    }
    
    func youDied() {
        currentRoom = 0.0
        speechButton.isHidden = true
        helpButton.setTitle("Restart", for: .normal)
        helpButton.isHidden = false
        straightButton.isHidden = true
        leftButton.isHidden = true
        rightButton.isHidden = true
        sneakButton.isHidden = true
        strengthButton.isHidden = true
        gameOver = true
        eventLabel.text = "Despite your best efforts, you fall to your current foe. Try again?"
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        if currentRoom == 1.0 {
            currentRoom += 0.1
            noticed = false
            if enemies.goblinIsAlive == true { // Goblin's room
                eventLabel.text = "You pick the left path. As you cautiously enter its room, you notice a drop in visibility, as the interior is dimly lit with only a single torch hung from the ceiling over an empty table. Despite this, you make out a small goblin with its back to you, facing another doorway dead ahead. How will you deal with this creature?"
                combatMode()
                currentEnemyHealth = enemies.goblinHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if enemies.goblinIsAlive == false {
                eventLabel.text = "You return to the dimly lit room. There is a door to the right and one ahead"
            }
        } else if currentRoom == 1.1 {
            if inCombat == false {
                eventLabel.text = "There is no pathway to the left"
            }
        } else if currentRoom == 2.1 {
            if inCombat == false {
                eventLabel.text = "There is no pathway to the left"
            }
        } else if currentRoom == 0.9 {
            currentRoom += 0.1
            eventLabel.text = "You double back into the main lobby. Nothing has changed about the room since you last visited: one door on the left where you came from, one straight ahead, and one to the right"
        } else if currentRoom == 1.9 { // Ghost's room from Witch's
            currentRoom += 0.1
            if enemies.ghostIsAlive == true {
                eventLabel.text = "You head through the left doorway. This room looks like a dining hall, with empty plates and mugs stacked on tables in each corner. A ghostly echo fills the room, and a translucent figure materializes in the center of the room. Its foggy eyes are fixed on you. What will you do?"
                combatMode()
                currentEnemyHealth = enemies.ghostHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if enemies.ghostIsAlive == false {
                eventLabel.text = "You return to the ghost's room. There is a doorway to the left, to the right, and ahead"
            }
        } else if currentRoom == 2.0 { // Hobgoblin's room from Ghost's
            currentRoom += 0.1
            if enemies.hobgoblinIsAlive == true {
                eventLabel.text = "This room is much darker than any you have previously been in. Still, you barely make out a sleeping hobgoblin, undisturbed by your entrance, in the middle of the room. You can see light peeking through the cracks of a door on the right. How will you deal with this creature?"
                combatMode()
                currentEnemyHealth = enemies.hobgoblinHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if enemies.hobgoblinIsAlive == false {
                eventLabel.text = "You return to the room once inhabited by the hobgoblin. In the darkness, you see a doorway ahead and to the right"
            }
        } else if currentRoom == 3.0 {
            eventLabel.text = "Is that a trapdoor you see to a hidden room??? Nope. Just more armor"
        } else if currentRoom == 4.0 {
            eventLabel.text = "I said forward, bud. Not left"
        }
    }
    @IBAction func straightButtonPressed(_ sender: UIButton) {
        helpButton.isHidden = true
        if currentRoom == 0.0 { // Lobby
            currentRoom += 1.0
            eventLabel.text = "After many hours of exploring, you, a brave adventurer, have discovered an ancient dungeon hidden in the forest. Throwing caution to the wind, you marched bravely inside in search of riches. The lobby is empty, save for a message engraved on the ground and three doorways located ahead, to the left, and to the right. The message reads: 'No turning back.' In fact, the way you came in from is mysteriously sealed shut. You can only go deeper into the dungeon. Which path will you choose?"
            healthLabel.isHidden = false
            healthLabel.text = "\(currentHealth)"
            staticHealthLabel.isHidden = false
            healButton.isHidden = false
            exploreMode()
        } else if currentRoom == 1.0 { // Ghost's room
            currentRoom += 1.0
            eventLabel.text = "The most direct way to the end of this dungeon will surely be dead ahead. You head through the doorway which shuts automatically behind you. This room looks like a dining hall, with empty plates and mugs stacked on tables in each corner. A ghostly echo fills the room, and a translucent figure materializes in the center of the room. Its foggy eyes are fixed on you. What will you do?"
            combatMode()
            currentEnemyHealth = enemies.ghostHealth
            enemyHealthLabel.text = "\(currentEnemyHealth)"
        } else if currentRoom == 1.1 { // Hobgoblin's room
            currentRoom += 1.0
            eventLabel.text = "You continue head through the door once patrolled by the goblin. As you enter, the doorway seals shut behind you. It seems as though this next room is even darker than the previous one. Still, you barely make out a sleeping hobgoblin, undisturbed by your entrance, in the middle of the room. You can see light peeking through the cracks of a door on the right. How will you deal with this creature?"
            noticed = false
            combatMode()
            currentEnemyHealth = enemies.hobgoblinHealth
            enemyHealthLabel.text = "\(currentEnemyHealth)"
        } else if currentRoom == 2.1 {
            if inCombat == false {
                eventLabel.text = "There is no pathway ahead"
            }
        } else if currentRoom == 0.9 { // Witch's room
            currentRoom += 1.0
            eventLabel.text = "You pass out of the room once guarded by the warrior and the door seals shut. The walls are made of stone and the room is bare, save for a witch in the center surrounded by skulls. She appears to be meditiating. How will you handle this potential threat?"
            noticed = false
            combatMode()
            currentEnemyHealth = enemies.witchHealth
            enemyHealthLabel.text = "\(currentEnemyHealth)"
        } else if currentRoom == 1.9 {
            eventLabel.text = "There is no pathway ahead"
        } else if currentRoom == 2.0 { // Knight's room
            currentRoom += 1.0
            eventLabel.text = "You continue deeper into the dungeon. As expected, the door shuts and seals. Inside is a large circular room full of weapon racks and pieces of armor on stands. An armory, perhaps? In the center of the room is a ridiculously sized full suit of armor, glove clasped around an inconceivably large mace. You step towards it, and the suit moves. 'WHAT' it hollers, spinning around and swinging the mace carelessly. You see a pair of eyes through small slits in the helmet, and no sign of any ear holes. Getting close might be tricky. How will you handle this foe?"
            noticed = false
            combatMode()
            currentEnemyHealth = enemies.knightHealth
            enemyHealthLabel.text = "\(currentEnemyHealth)"
        } else if currentRoom == 3.0 { // Final Boss room
            currentRoom += 1.0
            eventLabel.text = "With much effort, you push the intimidating door open, leading you into the final room. Like all the others, it slams shut and seals behind you. Inside is a plethora of gold, gems, and all other sorts of treasure. Grand stone pillars are the only things that grow out of the piles of valuables. At the very end of the hall is a wooden throne, modest in comparison to the rest of the room. A hooded figure sits in it. 'Welcome,' he says. 'Press that forward button and come here.'"
        } else if currentRoom == 4.0 {
            if killCount == 0 {
                pacifistEnding()
            } else if killCount == 5 {
                eventLabel.text = "I don't know whether to be impressed or horrified. You killed every single one of my children, hunted them down like animals. I get that this is just a game to you, but have a little class! Of course, this Genocide run won't be completed until you defeat me, the Final Boss!"
                genocideBoss = true
                combatMode()
                currentEnemyHealth = enemies.bossHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else {
                eventLabel.text = "I'm happy to see you made it. Did my obstacles slow you down? Clealy not enough, you're still here after all. You should've gotten some more practice killing the rest of them, as I might prove to be a little more difficult"
                neutralBoss = true
                combatMode()
                currentEnemyHealth = enemies.hardBossHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            }
        }
    }
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        if currentRoom == 1.0 { // Warrior's room
            currentRoom -= 0.1
            if enemies.warriorIsAlive == true {
                eventLabel.text = "You feel like this path is the right way to go. As you march through the doorway, you enter what appears to be an old burial crypt, with old stone tombs lining the walls and a door to the left. In the center stands a warrior, dressed in leather armor, with his sword planted in the ground. 'Halt!' he calls out, 'None venture deeper into this crypt live to return. Turn back now or I will be forced to stop you!' What will you do?"
                noticed = true
                combatMode()
                currentEnemyHealth = enemies.warriorHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else {
                eventLabel.text = "You find your way back to the warrior's room. It appears that any evidence of the warrior's presence disappeared without a trace. There is a door ahead and another to the left"
            }
        } else if currentRoom == 1.1 {
            currentRoom -= 0.1
            eventLabel.text = "You double back into the main lobby. Nothing has changed about the room since you last visited: one door on the left where you came from, one straight ahead, and one to the right"
        } else if currentRoom == 0.9 {
            eventLabel.text = "There is no pathway to the right"
        } else if currentRoom == 1.9 {
            eventLabel.text = "There is no pathway to the right"
        } else if currentRoom == 2.1 { // Ghost's room from Hobgoblin's
            currentRoom -= 0.1
            if enemies.ghostIsAlive == true {
                eventLabel.text =  "This room looks like a dining hall, with empty plates and mugs stacked on tables in each corner. A ghostly echo fills the room, and a translucent figure materializes in the center of the room. Its foggy eyes are fixed on you. What will you do?"
                combatMode()
                currentEnemyHealth = enemies.ghostHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if enemies.ghostIsAlive == false {
                eventLabel.text = "You return to the dining hall. There is a doorway ahead, to the left, and to the right"
            }
        } else if currentRoom == 2.0 { // Witch's room from Ghost's
            currentRoom -= 0.1
            if enemies.witchIsAlive == true {
                eventLabel.text = "You leave the ancient dining hall. The walls are made of stone and the room is bare, save for a witch in the center surrounded by skulls. She appears to be meditiating. How will you handle this potential threat?"
                noticed = false
                combatMode()
                currentEnemyHealth = enemies.witchHealth
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if enemies.witchIsAlive == false {
                eventLabel.text = "You make your way back to the skull-laden room where the witch once meditated. There are doorways to the left and ahead"
            }
        } else if currentRoom == 3.0 {
            eventLabel.text = "Nothing but rusty swords and oversized armor to the right"
        } else if currentRoom == 4.0 {
            easterEggTracker += 1
            if easterEggTracker < 13 {
                eventLabel.text = "Look man, nothing cool's gonna happen if you keep trying to go other directions. Just press the forward button"
            } else if easterEggTracker == 13 {
                potionsCount += 20
                healButton.setTitle("Heal(\(potionsCount))", for: .normal)
                currentHealth += 50
                healthLabel.text = "\(currentHealth)"
                eventLabel.text = "Good job you found the Easter Egg. Here's some free health and potions as a reward. This game was made by me, Connor Marlin, as a final project for my Learn to Code In Swift summer course through Boston College Ireland. Special thanks to Professor Gallaugher for teaching me how to use this and Eric Skiff for the music. Other than that, just remember these useless numbers: 1560 0565 7602"
            } else {
                eventLabel.text = "Good job you found the Easter Egg. Here's some free health and potions as a reward. This game was made by me, Connor Marlin, as a final project for my Learn to Code In Swift summer course through Boston College Ireland. Special thanks to Professor Gallaugher for teaching me how to use this. Other than that, just remember these useless numbers: 1560 0565 7602"
            }
        }
    }
    
    @IBAction func sneakButtonPressed(_ sender: UIButton) { // MARK:- sneak sequences for WARRIOR
        if currentRoom == 0.9 {
            sneakDiceRoll()
            if eventResult == 1 {
                eventLabel.text = "You perform a quick attack on the warrior with your dagger. He parries. 'Pathetic!' he jeers as he chops at your shoulder with his blade"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
            } else if eventResult == 2 {
                eventLabel.text = "You strike swiftly with your dagger. While the warrior attempts to dodge it, your blade meets him on the shoulder. 'A lucky hit. You shall not land another!' The warrior returns with a blow to your chest"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
                currentEnemyHealth -= 1
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if eventResult == 3 {
                eventLabel.text = "Your dagger whistles through the air, piercing the warrior's leather armor with a critical hit! He grunts in protest, too taken aback by the strike to return one of his own"
                currentEnemyHealth -= 2
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            }
            if currentEnemyHealth <= 0 {
                enemies.warriorIsAlive = false
                foeDefeated()
            }
        } else if currentRoom == 1.1 { // MARK:- sneak sequence for GOBLIN
            if noticed == false {
                diceRoll()
                noticed = true
                if eventResult == 1 {
                    eventLabel.text = "You sneak up to the goblin in an attempt to subdue the creature stealthily, but your foot is caught on a loose stone, and the creature notices your error. It dodges your attack and returns with a hit of its own"
                    currentHealth -= 1
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "You silently glide across the room towards your target. The goblin is unaware as you strike at its back, injuring the creature severely. Caught off guard, the goblin is too stunned to attack you"
                    currentEnemyHealth -= 3
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "In an instant, you cover the distance to the goblin, and with a well placed blow, you dispatch your foe before it could even know what happened"
                    enemyHealthLabel.text = "0"
                    enemies.goblinIsAlive = false
                    killCount += 1
                    exploreMode()
                }
                if currentEnemyHealth <= 0 {
                    enemies.goblinIsAlive = false
                    foeDefeated()
                }
            } else if noticed == true {
                sneakDiceRoll()
                if eventResult == 1 {
                    eventLabel.text = "You take a quick strike at the goblin with your dagger, but miss. Before you can recover, the goblin strikes back"
                    currentHealth -= 1
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "You swipe at the goblin with your dagger, wounding it. The creature claws back at you in retort"
                    currentHealth -= 1
                    healthLabel.text = "\(currentHealth)"
                    currentEnemyHealth -= 1
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "You strike swiftly at the creature with your dagger. Your blow lands well and critically hits the goblin"
                    currentEnemyHealth -= 2
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
                if currentEnemyHealth <= 0 {
                    enemies.goblinIsAlive = false
                    foeDefeated()
                }
            }
        } else if currentRoom == 2.1 { // MARK:- sneak sequence for HOBGOBLIN
            if noticed == false {
                diceRoll()
                noticed = true
                if eventResult == 1 {
                    eventLabel.text = "You try to sneak up to the hobgoblin, but it hears you approach and stabs at you with a jagged blade"
                    currentHealth -= 1
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "Your light feet pay off. The hobgoblin experiences a rude awakening as you jab at it with your dagger. It scrambles to its feet, giving you enough time to fit another strike in"
                    currentEnemyHealth -= 3
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "You silently approach the creature and deliver a critical blow with your dagger"
                    currentEnemyHealth -= 5
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
                if currentHealth <= 0 {
                    enemies.hobgoblinIsAlive = false
                    foeDefeated()
                }
            } else if noticed == true {
                sneakDiceRoll()
                if eventResult == 1 {
                    eventLabel.text = "You swipe at the hobgoblin with your dagger, but your strike is parried. The creature swings at you and the blade catches you on the shoulder"
                    currentHealth -= 2
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "You jab at the hobgoblin's chest. While your blow meets its mark, the hobgoblin also strikes you on your flank"
                    currentEnemyHealth -= 1
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                    currentHealth -= 2
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "A well placed strike hits the hobgoblin and knocks it off balance"
                    currentEnemyHealth -= 2
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
                if currentEnemyHealth <= 0 {
                    enemies.hobgoblinIsAlive = false
                    foeDefeated()
                }
            }
        } else if currentRoom == 2.0 { // MARK:- sneak sequence for GHOST
            eventLabel.text = "You attempt to slice the ghost with your trusty dagger, but the blade glides right through its belly. The ghost frowns and swings at you with a ghastly blade. Unfortunately, this blade does not harmlessly glide through you"
            currentHealth -= 5
            healthLabel.text = "\(currentHealth)"
        } else if currentRoom == 1.9 { // MARK:- sneak sequence for WITCH
            if noticed == false {
                diceRoll()
                noticed = true
                if eventResult == 1 {
                    eventLabel.text = "You try to sneak up on the witch, but her eyes open before you can get too close. She zaps you with a spell and cackles"
                    currentHealth -= 3
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "You sneak up to the witch, close enough to her her murmering unknown spells. You stab at her with your dagger, causing her to gasp in pain. Startled, she pushes back with an invisible spell"
                    currentEnemyHealth -= 3
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "Even with potentially arcane hearing, you swiftly approach the witch and strike her with a critical hit. She flies back to get some distance between you and her"
                    currentEnemyHealth -= 5
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
            } else if noticed == true {
                sneakDiceRoll()
                if eventResult == 1 {
                    eventLabel.text = "You swipe at the witch with your quick dagger. Despite the speed, she raises a palm and your blade freezes inches from her heart. Her fist clenches and a lightning bolt shoots out and strikes your chest"
                    currentHealth -= 3
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "The witch tries to stop you, but you quickly poke through her robe and hit her shoulder. Enraged, she shoots a burning beam of green light at your head"
                    currentEnemyHealth -= 1
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                    currentHealth -= 3
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "As you move in to strike the witch, she fires a bolt of flame at you. You dodge and hit her for a hit strong enough to stun her"
                    currentEnemyHealth -= 2
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
                if currentEnemyHealth <= 0 {
                    enemies.witchIsAlive = false
                    witchDefeated()
                }
            }
        } else if currentRoom == 3.0 { // MARK:- sneak sequence for KNIGHT
            if noticed == false {
                diceRoll()
                noticed = true
                if eventResult == 1 {
                    eventLabel.text = "You try to sneak up to the armored individual, however his careless swinging catches you on the shoulder. 'WHAT' he yells, now focused on you"
                    currentHealth -= 5
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "Weaving through the swings of the enemy's mace and gauntlet, you get close enough to sneak your dagger into a chink of his armor 'WHAT'"
                    currentEnemyHealth -= 3
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "Silence is clearly not required. You bound up to the armored man and poke at a gap in his armor, dealing critical damage and causing him to stumble. 'OUCH! WHAT'"
                    currentEnemyHealth -= 5
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
            } else if noticed == true {
                sneakDiceRoll()
                if eventResult == 1 {
                    if helmetOn == true {
                        eventLabel.text = "You try to strike quickly at the knight, but your dagger bounces off the heavy armor. A rogue swing of his mace finds its way to your head. That's gonna hurt"
                        currentHealth -= 5
                        healthLabel.text = "\(currentHealth)"
                    } else if helmetOn == false {
                        eventLabel.text = "You try to strike quickly at the knight, but your dagger bounces off the heavy armor. He swings the mace directly at your head. That's gonna hurt"
                        currentHealth -= 5
                        healthLabel.text = "\(currentHealth)"
                    }
                } else if eventResult == 2 {
                    if helmetOn == true {
                        eventLabel.text = "With the help of your nimble fingers, the dagger finds its way into the cracks of the armor. 'WHAT' he yells, swinging his mace in your general direction and clipping your shoulder"
                        currentHealth -= 5
                        healthLabel.text = "\(currentHealth)"
                        currentEnemyHealth -= 1
                        enemyHealthLabel.text = "\(currentEnemyHealth)"
                    } else if helmetOn == false {
                        eventLabel.text = "With the help of your nimble fingers, the dagger finds its way into the cracks of the armor. 'STOP THAT' he yells, swinging his mace and clipping your shoulder as you try to dodge"
                        currentHealth -= 5
                        healthLabel.text = "\(currentHealth)"
                        currentEnemyHealth -= 1
                        enemyHealthLabel.text = "\(currentEnemyHealth)"
                    }
                } else if eventResult == 3 {
                    if helmetOn == true {
                        eventLabel.text = "As the knight spins and whirls, you spot an especially large gap in the armor at the top of the backplate. You leap onto his back and sink the dagger into his back. Before the knight has a chance to swat you off, you jump down and retreat to a safe distance"
                        currentEnemyHealth -= 2
                        enemyHealthLabel.text = "\(currentEnemyHealth)"
                    } else if helmetOn == false {
                        eventLabel.text = "The knight attempts to crush you beneath his mace before you can attack. You barely get out of his way, but in doing so, you spot a weak spot and sink your dagger into it, causing the knight to howl in pain"
                        currentEnemyHealth -= 2
                        enemyHealthLabel.text = "\(currentEnemyHealth)"
                    }
                }
                if currentEnemyHealth <= 0 {
                    enemies.knightIsAlive = false
                    foeDefeated()
                }
            }
        } else if currentRoom == 4.0 { // MARK:- sneak sequence for FINAL BOSS
            if neutralBoss == true {
                sneakButton.setTitle("Sneak", for: .normal)
                sneakDiceRoll()
                if eventResult == 1 {
                    eventLabel.text = "Omae wa mou shindeiru"
                    sneakButton.setTitle("NANI", for: .normal)
                } else if eventResult == 2 {
                    eventLabel.text = "While your back is turned, I sneak up behind you and tie your shoes together. When you attempt to walk, your laces tighten, causing you too fall to the gound and smash your nose on the solid floor"
                    currentHealth -= 7
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "You cast your 10-sided die and roll a perfect 10! Meanwhile I roll a 1,000 on my infinite-sided die, dealing critical damage against you"
                    currentHealth -= 7
                    healthLabel.text = "\(currentHealth)"
                }
            } else if genocideBoss == true {
                sneakDiceRoll()
                if eventResult == 1 {
                    eventLabel.text = "You really just brought a knife to a gunfight *fires flintlock*"
                    currentHealth -= 7
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "Ouch ooooh ouch ow pointy dagger"
                    currentHealth -= 7
                    healthLabel.text = "\(currentHealth)"
                    currentEnemyHealth -= 1
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "Sample text for landing critical sneak hit on enemy"
                    currentEnemyHealth -= 2
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
            }
            if currentEnemyHealth <= 0 {
                enemies.bossIsAlive = false
                finalBossDefeated()
            }
        }
                if currentHealth <= 0 {
            healthLabel.text = "0"
            youDied()
        }
    }
    @IBAction func speechButtonPressed(_ sender: UIButton) {
        if currentRoom == 1.1 { // MARK:- speech sequence for GOBLIN
            eventLabel.text = "Naively, you call out to the goblin. Upon hearing you, it snarls and takes a swipe at you with its claws"
            noticed = true
            currentHealth -= 1
            healthLabel.text = "\(currentHealth)"
        } else if currentRoom == 2.1 { // MARK:- speech sequence for HOBGOBLIN
            if noticed == false {
                eventLabel.text = "Perhaps you can reason with this creature. After calling out to it, the hobgoblin stirs and draws its sword. It babbles some unintelligible dialect, and you doubt it understood you as it swings its sword at you"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
                noticed = true
            } else if noticed == true {
                eventLabel.text = "You don't think this creature wants to talk to you"
            }
        } else if currentRoom == 0.9 { // MARK:- speech sequence for WARRIOR
            diceRoll()
            if eventResult == 1 {
                eventLabel.text = "You begin to speak, but your voice cracks. 'Die, prepubescent wench!' the warrior cries before you can attempt to speak again, lunging at you with his sword"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
            } else if eventResult == 2 {
                eventLabel.text = "You wish to calm the warrior down. You hold your arms up and explain that you don't want to hurt him, but you must continue to the end of the path. 'Too many have died with that very objective' he says in a somber tone. 'Turn back or I will slay you were you stand.'"
            } else if eventResult == 3 {
                eventLabel.text = "You place your foot firmly on the ground. You tell the warrior that nothing will stop you on your quest for fortune. The warrior sighs. 'What lies at the end of this dungeon is unlike any creature of this world. But I see that you will not be swayed. Go on, meet your fate.' he steps aside, planting his sword back in the ground"
                enemies.warriorIsAlive = false
                exploreMode()
            }
        } else if currentRoom == 2.0 { // MARK:- speech sequence for GHOST
            spellDiceRoll()
            if eventResult == 1 {
                eventLabel.text = "You recall an old spell used to banish spirits such as this one. You do your best to recite the chant, but you mess up the words. You might have said something offensive in the archaic tongue, as the ghost gasps before swinging at you with a closed fist"
                currentHealth -= 1
                healthLabel.text = "\(currentHealth)"
            } else if eventResult == 2 {
                eventLabel.text = "You recall an old spell used to banish spirits such as this one. You do your best to recite the chant, but you mess up the words. The ghost continues floating, undisturbed. Perhaps another try?"
            } else if eventResult == 3 {
                eventLabel.text = "You recall an old spell used to banish spirits such as this one. As soon as you call upon the banishing magic, the ghost hollers before dissipating into a cloud of ghostly gas"
                enemies.ghostIsAlive = false
                enemyHealthLabel.text = "0"
                exploreMode()
            }
        } else if currentRoom == 1.9 { // MARK:- speech sequence for WITCH
            if noticed == false {
                eventLabel.text = "Skulls don't necessarily mean someone's evil, right? You call out to the witch and wave. Her eyes open and she grins maniacally. She charges a magical attack and sends it at you. You make a mental note that skulls probably mean she's evil"
                currentHealth -= 3
                healthLabel.text = "\(currentHealth)"
                noticed = true
            } else if noticed == true {
                eventLabel.text = "Skulls probably mean that she's evil"
                currentHealth -= 3
                healthLabel.text = "\(currentHealth)"
            }
        } else if currentRoom == 3.0 { // MARK:- speech sequence for KNIGHT
            if helmetOn == true {
                eventLabel.text = "You call out to the knight in an attempt to reason with him. Muffled by his helmet, he calls back: 'WHAT'"
            } else if helmetOn == false {
                eventLabel.text = "You rush to explain to the knight that you wish to pass without harming him further. He scratches his bald head. 'Why didn't you say so? Go on ahead.' He steps aside, revealing a large, jewl-encrusted door, presumably to the final room. 'Before you go, I must warn you: beyond that door lies the Dungeon Master. He will judge you for your actions.' With that ominous warning, he puts his helmet back on and goes silent"
                enemies.knightIsAlive = false
                exploreMode()
            }
        } else if currentRoom == 4.0 { // MARK:- speech sequence for FINAL BOSS
            if neutralBoss == true {
                eventLabel.text = "What's that? I can't hear you, it seems like someone hid your Speech button"
                speechButton.isHidden = true
            } else if genocideBoss == true {
                diceRoll()
                if eventResult == 1 {
                    eventLabel.text = "WHAT??? Haha get it that was the gag for that one guy you didn't have to kill"
                } else if eventResult == 2 {
                    eventLabel.text = "I'm surpised you'd want to talk your way out of this one after you killed everyone else"
                } else if eventResult == 3 {
                    eventLabel.text = "Please don't kill me"
                }
            }
        }
        if currentHealth <= 0 {
            healthLabel.text = "0"
            youDied()
        }
    }
    @IBAction func strengthButtonPressed(_ sender: UIButton) {
        if currentRoom == 1.1 { // MARK:- strength sequence for GOBLIN
            strengthDiceRoll()
            noticed = true
            if eventResult == 1 {
                eventLabel.text = "You charge the goblin with your longsword and attempt to cleave the head clear off. The goblin dodges, however, and punishes your error by scratching at you with razor sharp claws"
                currentHealth -= 1
                healthLabel.text = "\(currentHealth)"
            } else if eventResult == 2 {
                eventLabel.text = "You use your longsword to cut at the goblin, damaging it. The wretched creature winces and swipes at you"
                currentHealth -= 1
                healthLabel.text = "\(currentHealth)"
                currentEnemyHealth -= 3
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if eventResult == 3 {
                eventLabel.text = "You attack ferociously at the goblin with all your might. Even as it attempts to dodge the flurry, you slay the creature where it lays"
                enemyHealthLabel.text = "0"
                killCount += 1
                exploreMode()
                enemies.goblinIsAlive = false
            }
            if currentEnemyHealth <= 0 {
                enemies.goblinIsAlive = false
                foeDefeated()
            }
        } else if currentRoom == 2.1 { // MARK:- strength sequence for HOBGOBLIN
            strengthDiceRoll()
            noticed = true
            if eventResult == 1 {
                eventLabel.text = "You charge the hobgoblin with your longsword, but it manages to block your attack and jab at you with its own blade"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
            } else if eventResult == 2 {
                eventLabel.text = "You attack the hobgoblin with a flurry of your trusty longsword. The attack hits, but the creature makes its feeling on being stabbed known by stabbing you in return"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
                currentEnemyHealth -= 3
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if eventResult == 3 {
                eventLabel.text = "You call out a battlecry and charge the hobgoblin down. Too startled to react, the hobgoblin receives a critical blow and is too dazed to retort"
                currentEnemyHealth -= 5
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            }
            if currentEnemyHealth <= 0 {
                enemies.hobgoblinIsAlive = false
                foeDefeated()
            }
        } else if currentRoom == 0.9 { // MARK:- strength sequence for WARRIOR
            strengthDiceRoll()
            noticed = true
            if eventResult == 1 {
                eventLabel.text = "You swing your longsword at the warrior. He grins gleefully and catches your blade with an armored glove, stabbing at you"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
            } else if eventResult == 2 {
                eventLabel.text = "You aim a low blow at the warrior. He cannot parry in time to block the strike as it hits his knee. 'Curses!' he cries. While the hit landed, your upper body is exposed, and the warrior strikes at your shoulder"
                currentHealth -= 2
                healthLabel.text = "\(currentHealth)"
                currentEnemyHealth -= 3
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if eventResult == 3 {
                eventLabel.text = "Sprinting at the warrior, you jumpkick his chest. Knocked off balance, you swing your longsword and the blade connects with his stomach for a critical hit. The warrior is stunned"
                currentEnemyHealth -= 5
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            }
            if currentEnemyHealth <= 0 {
                enemies.warriorIsAlive = false
                foeDefeated()
            }
        } else if currentRoom == 2.0 { // MARK:- strength sequence for GHOST
            eventLabel.text = "You ready your blade and stab at the ghost. At this moment you realize the sword is not made of silver, as the tip merely pokes into the ghost's belly. It chuckles as if tickled, points a glowing finger at you, and casts an otherworldly bolt of electricity at you"
            currentHealth -= 5
            healthLabel.text = "\(currentHealth)"
        } else if currentRoom == 1.9 { // MARK: - strength sequence for WITCH
            strengthDiceRoll()
            noticed = true
            if eventResult == 1 {
                eventLabel.text = "You try to swing your longsword, but a magical bolt pushes your arm back, while another hits you in the leg, wounding you"
                currentHealth -= 3
                healthLabel.text = "\(currentHealth)"
            } else if eventResult == 2 {
                eventLabel.text = "You strike with the longsword. The witch's robes provide little protection, allowing for your strong attack to deal more damage than usual. She shrieks and sends a lightning bolt to your chest"
                currentHealth -= 3
                healthLabel.text = "\(currentHealth)"
                currentEnemyHealth -= 4
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            } else if eventResult == 3 {
                eventLabel.text = "The witch sends a ball of energy at you. You swing your sword once to deflect the ball, then once again to deliver an especially strong critical blow against the unprotected witch"
                currentEnemyHealth -= 6
                enemyHealthLabel.text = "\(currentEnemyHealth)"
            }
            if currentEnemyHealth <= 0 {
                enemies.witchIsAlive = false
                witchDefeated()
            }
        } else if currentRoom == 3.0 { // MARK:- Strength sequence for KNIGHT
            strengthDiceRoll()
            noticed = true
            if eventResult == 1 {
                if helmetOn == true {
                    eventLabel.text = "You try to swing at your large adversary with your longsword. The blade bounces off the armor with a loud clang, briefly alerting the knight to your presence. His returning blow knocks you backwards 'WHAT'"
                    currentHealth -= 5
                    healthLabel.text = "\(currentHealth)"
                } else if helmetOn == false {
                    eventLabel.text = "You go for a swing at the knight with your longsword. He swats it back easily with his gauntlet, then slams his mace into you. 'NICE TRY!' he yells"
                    currentHealth -= 5
                    healthLabel.text = "\(currentHealth)"
                }
            } else if eventResult == 2 {
                if helmetOn == true {
                    eventLabel.text = "Maneuvering your larger longsword to a weak spot on this foe will be tricky, but you manage to hit a gap in the armor, dealing some damage. This minor victory is overshadowed by the knight knocking you away with his trademark call: 'WHAT'"
                    currentHealth -= 5
                    healthLabel.text = "\(currentHealth)"
                    currentEnemyHealth -= 3
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if helmetOn == false {
                    eventLabel.text = "You manage to strike a spot in between the plates of his armor. He grunts in pain and kicks you with a heavy boot"
                    currentHealth -= 5
                    healthLabel.text = "\(currentHealth)"
                    currentEnemyHealth -= 3
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
            } else if eventResult == 3 {
                if helmetOn == true {
                    eventLabel.text = "You decide that targeted strikes won't do it. In the hopes of at least knocking the knight unconscious, you leap up and aim a heavy blow for the head. It collides and, to your surprise, knocks the helmet clean off, revealing a hairless, yet very human, head. 'THERE YOU ARE' he bellows, starting towards you"
                    currentEnemyHealth -= 5
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                    helmetOn = false
                } else if helmetOn == false {
                    eventLabel.text = "You aim another heavy blow at the knight's exposed head. It lands for a critical hit, knocking him backwards"
                    currentEnemyHealth -= 5
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
            }
            if currentEnemyHealth <= 0 {
                enemies.knightIsAlive = false
                foeDefeated()
            }
        } else if currentRoom == 4.0 { // MARK:- Strength sequence for FINAL BOSS
            if neutralBoss == true {
                strengthDiceRoll()
                if eventResult == 1 {
                    eventLabel.text = "You try to draw your sword, but then you stab yourself. Repeatedly. Ouch."
                    currentHealth -= 7
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "Oh no! The all powerful Dungeon Master defeated by a mere mortal? How ever could this be? Oh the absence of pain! I'm not bleeding all over the floor! Oh nooooooooo *yawn*"
                    currentHealth -= 7
                    healthLabel.text = "\(currentHealth)"
                    currentEnemyHealth -= 1
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "ERROR 404: strength.attack could not execute beacuse attributes.playerStrength is of an insufficient value"
                }
            } else if genocideBoss == true {
                strengthDiceRoll()
                if eventResult == 1 {
                    eventLabel.text = "Too slow! Should have used the Speed button"
                    currentHealth -= 4
                    healthLabel.text = "\(currentHealth)"
                } else if eventResult == 2 {
                    eventLabel.text = "Not a bad hit there..."
                    currentHealth -= 4
                    healthLabel.text = "\(currentHealth)"
                    currentEnemyHealth -= 3
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                } else if eventResult == 3 {
                    eventLabel.text = "*visibly stunned from a critical hit*"
                    currentEnemyHealth -= 5
                    enemyHealthLabel.text = "\(currentEnemyHealth)"
                }
            }
            if currentEnemyHealth <= 0 {
                enemies.bossIsAlive = false
                finalBossDefeated()
            }
        }
        if currentHealth <= 0 {
            healthLabel.text = "0"
            youDied()
        }
    }
    
    @IBAction func healButtonPressed(_ sender: UIButton) {
        if currentRoom == 3.0 {
            if currentHealth == 20 {
                eventLabel.text = "It would be unwise to heal yourself without being injured"
            } else if currentHealth >= 21 {
                currentHealth = 20
                healthLabel.text = "\(currentHealth)"
            } else if potionsCount == 0 {
                eventLabel.text = "You are out of potions"
            } else {
                currentHealth += 5
                healthLabel.text = "\(currentHealth)"
                potionsCount -= 1
                healButton.setTitle("Heal(\(potionsCount))", for: .normal)
            }
        } else if currentRoom == 4.0 {
            if currentHealth == 20 {
                eventLabel.text = "It would be unwise to heal yourself without being injured"
            } else if currentHealth >= 21 {
                currentHealth = 20
                healthLabel.text = "\(currentHealth)"
            } else if potionsCount == 0 {
                eventLabel.text = "You are out of potions"
            } else {
                currentHealth += 5
                healthLabel.text = "\(currentHealth)"
                potionsCount -= 1
                healButton.setTitle("Heal(\(potionsCount))", for: .normal)
            }
        } else {
            if currentHealth == 20 {
                eventLabel.text = "It would be unwise to heal yourself without being injured"
            } else if currentHealth >= 21 {
                currentHealth = 20
                healthLabel.text = "\(currentHealth)"
            } else if potionsCount == 0 {
                eventLabel.text = "You are out of potions"
            } else {
                currentHealth += 5
                healthLabel.text = "\(currentHealth)"
                potionsCount -= 1
                healButton.setTitle("Heal(\(potionsCount))", for: .normal)
            }
        }
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        if gameOver == false {
          eventLabel.text = "Dungeon Delver is a text based adventure, meaning everything that happens in this game will be told to you through messages like this. Take cues from these messages to decide what action to complete. The top buttons will move you throughout the room when you are able to. The bottom buttons, Sneak, Speech, and Strength, are your combat actions. Sneak normally does less damage, but has a higher chance of hitting. It may do more if an enemy doesn't seem to notice you. Strength acts the opposite: more damage, but less chance of hitting. Speech lets you talk to your foes, as you are able to get out of fighting some of them. The Heal button up top will restore your health. Press forward to enter the dungeon, and good luck!"
        } else if gameOver == true {
           restart()
            helpButton.setTitle("Help", for: .normal)
        }
    }
}

extension UIView {
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
