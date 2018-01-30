//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Siyabonga Zondo on 2018/01/23.
//  Copyright © 2018 Siyabonga Zondo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecoder : AVAudioRecorder!

    @IBOutlet weak var RecordingLbl: UILabel!
    @IBOutlet weak var Recordbutton: UIButton!
    @IBOutlet weak var StopRecrdBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StopRecrdBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear called")
        
    }
    

    @IBAction func Recordaudio(_ sender: Any) {
        print("record button was pressed")
        RecordingLbl.text = "Recording in progress..."
        Recordbutton.isEnabled = false
        StopRecrdBtn.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecoder = AVAudioRecorder(url: filePath!, settings: [ : ])
        audioRecoder.delegate = self
        audioRecoder.isMeteringEnabled = true
        audioRecoder.prepareToRecord()
        audioRecoder.record()
    }
    
    @IBAction func StopRecording(_ sender: Any) {
        
        RecordingLbl.text = "Tap to record"
        Recordbutton.isEnabled = true
        StopRecrdBtn.isEnabled = false
        
        audioRecoder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {performSegue(withIdentifier: "stopRecording", sender: audioRecoder.url)
        }else{print("recording was not successful")}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording"){
            
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedaudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedaudioURL
        }
    }
    
}

