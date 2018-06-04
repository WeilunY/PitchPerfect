//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Weilun Yao on 6/2/18.
//  Copyright © 2018 Weilun Yao. All rights reserved.
//

import UIKit
import AVFoundation // import the class

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear is called")
    }
    
    // change UI state
    func configureUI(recording: Bool){
        if recording{
            print("record button is pressed")
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        } else {
            print("stop button is pressed")
            recordingLabel.text = "Tap to Record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    // MARK : record audio
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(recording: true)
        
        // path set up
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String   // set the file saving directory path
        let recordingName = "recorderVoice.wav"     // set the file name
        let pathArray = [dirPath, recordingName]    // combine directory path with recording name to for the file path
        let filePath = URL(string: pathArray.joined(separator: "/"))     // create the url for file path
        
        //print(filePath)
        
        // session set up
        let session = AVAudioSession.sharedInstance()       // set up the avaudio session, shared across all apps in device
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)      // play and record trhe audio
        
        // recorder set up and run
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = false
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    // MARK: stop recording
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recording: false)
        
        // Stop the recorder
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // from delgate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            print("finished recording")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) // perform the segue way to the second view
        } else {
            print("recroding failed")
        }
    }
    
    // prepare before sending the segue way
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController  // set the destination
            let recordedURL = sender as! URL   // prepare the url as sender
            playSoundsVC.recordedAudioURL = recordedURL   // set the variable in the destination
        }
    }
    
}

