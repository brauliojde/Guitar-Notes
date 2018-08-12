//
//  FirstViewController.swift
//  Guitar Notes
//
//  Created by Braulio De La Torre on 5/23/18.
//  Copyright © 2018 Braulio. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController {
    
    var timer: Timer?
    let tuner = Tuner()
    
    /* Arrays */
    var pitches = [Double]()
    var recNotes = [String]()
    var shortmem = [String]() //short memory array in order to check notes to add to recNotes
    
    /* Vars */
    var boolRec = 0
    var noteString = ""
    var noteCount = 0
    
    //** Buttons and Labels on the App **//
    
    @IBOutlet weak var displayNotes: UIButton!
    @IBAction func displayNotes(_ sender: Any) {
        deleteNotes()
    }
    @IBOutlet weak var notestoDisplay: UILabel!
    
    @IBOutlet weak var curNote: UILabel!
    @IBOutlet weak var checkFr: UIButton!
    @IBOutlet weak var freq: UILabel!
    
    @IBOutlet weak var recButton: UIButton!
    
    @IBAction func recButton(_ sender: Any) {
        if(boolRec==0){
            boolRec = 1
        } else{
            boolRec = 0
        }
    }
    
    @IBAction func checkFr(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkFreq), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var stopFr: UIButton!
    
    @IBAction func stopFr(_ sender: Any) {
        timer?.invalidate()
    }
    
    @IBOutlet weak var wavelength: UILabel!
    //*** END Buttons & Labels ***//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tuner.startMonitoring()
        checkFreq()
        
        //Makes Record Button Rounded
        recButton.layer.cornerRadius = 10
        recButton.clipsToBounds = true
        
        //Same for display notes button
        displayNotes.layer.cornerRadius = 10
        displayNotes.clipsToBounds = true
        
        //Same for displaying notes
        notestoDisplay.layer.cornerRadius = 15
        notestoDisplay.clipsToBounds = true
        
        pitches.append(16.35)
        
        //fill array with all the notes for octaves 2-6
        for x in 1...72 {
            let y = Double(x)
            
            let exp = Double(y/12.00)
            
            let power = pow(2.0, exp)
            
            let hz = power*16.35
            
            pitches.append(Double(hz))
            print("Frequency")
            print(x)
            print(hz)
        }
        
        notestoDisplay.text = noteString


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Obtains frequency information from microphone and displays it on app */
    func checkFreq(){
        
        let soundF = tuner.getFreq()
        let note = frequencyToNote(freq: soundF).description
        let amplitude = tuner.getWaveL()
        
        
        /* Gets Information from Sound and Displays it */
        curNote.text = note
        
        if(amplitude > 0.01){
            
            freq.text = String(soundF)
            wavelength.text = String(amplitude)
//          wavelength.text = String(343/soundF)
        
        
            /* Sends notes to be recorded */
            /* only if record button has been pressed && sound is higher than a certain level */
            if( boolRec==1 ){
                recordNotes(note: note)
            }
        }

    }
    
    /***Important***/
    /* Only Frequencies between 16.35 and 1046hz are able to be registered */
    /* which means that the array is only 60 cells */
    func frequencyToNote(freq: Double)->Note{
        
        var bestFreq = 0
        var min = 100.0
        var difference = 100.0
        
        
        for hz in pitches{
            
            difference = abs(freq-hz)

            if(difference<min){
                min = difference
                bestFreq = pitches.index(of: hz)!
            }

            
        }
        
        
        /* bestFreq is the indicie of the array */
        switch bestFreq {
            
        case 0,12,24,36,48,60,72:
            return Note.c(nil)
        case 1,13,25,37,49,61:
            return Note.c(.Sharp)
        case 2,14,26,38,50,62:
            return Note.d(nil)
        case 3,15,27,39,51,63:
            return Note.d(.Sharp)
        case 4,16,28,40,52,64:
            return Note.e(nil)
        case 5,17,29,41,53,65:
            return Note.f(nil)
        case 6,18,30,42,54,66:
            return Note.f(.Sharp)
        case 7,19,31,43,55,67:
            return Note.g(nil)
        case 8,20,32,44,56,68:
            return Note.g(.Sharp)
        case 9,21,33,45,57,69:
            return Note.a(nil)
        case 10,22,34,46,58,70:
            return Note.a(.Sharp)
        case 11,23,35,47,59,71:
            return Note.b(nil)
        default:
            return Note.b(.Flat)
        }
        

        
    }
    
    /* Function that records notes into an array */
    /* Notes will be recorded every 10th of a second */
    /* timer interval is in function/button checkFr */
    func recordNotes(note: String){
        
        
        
        if(noteCount == 3){
            noteCount = 0
            shortmem.removeAll()
            
        }
        
        /* shortmem is the array which stores 3 notes 
            if these 3 notes are the same the note is
            printed to the screen       */
        if(shortmem.isEmpty){
            shortmem.append(note)
   
        } else if(shortmem[0] == note && noteCount<3){
            shortmem.append(note)
            
        } else if(shortmem[0] != note){
            shortmem.removeAll()
            noteCount = 0
            shortmem.append(note)
            
        }


        
        /* If the same note is in 3 cells then display it as Note played */
        if (noteCount == 2 ){
            print("Note is first, then note in array ")
            print(note)
            print(shortmem[0])
            print(shortmem[1])
            print(shortmem[2])
            print(noteCount)
            
            if( shortmem[0]==shortmem[1] && shortmem[1]==shortmem[2] ){
//              noteString.append(recNotes[noteCount-1])
                noteString.append(shortmem[0])
                noteString.append(" ")
            }
        }
        
        /* increase count because note is always added */
        noteCount += 1
        
        /* Update String Displayed */
        notestoDisplay.text = noteString
    }
    
    /* Deletes all notes in the array to start new */
    func deleteNotes(){
        noteString.removeAll()
        noteCount = 0
        noteString = ""
        notestoDisplay.text = noteString


    }
    
    
    

}

