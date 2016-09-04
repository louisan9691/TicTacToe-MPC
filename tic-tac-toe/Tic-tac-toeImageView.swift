//
//  Tic-tac-toeImageView.swift
//  tic-tac-toe
//
//  Created by Louis An on 3/09/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class Tic_tac_toeImageView: UIImageView {

    var player: String?
    var activated: Bool! = false
    
    func setPerson(player:String){
        self.player = player
        
        if activated == false{
            if player == "x"{
                self.image = UIImage(named: "x")
            }else{
                self.image = UIImage (named: "o")
            }
            activated = true
        }
    }
    
}
