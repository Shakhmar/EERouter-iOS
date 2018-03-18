import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var currentMaxAccX:Double = 0.0
    var currentMaxAccY:Double = 0.0
    var currentMaxAccZ:Double = 0.0
    var manager = CMMotionManager()
    //MARK: - Properties and Constants
    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let startColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
    // values for the pedometer data
    var numberOfSteps:Int! = nil
    var Steps = [Int]()
    var Direc = [Int]()
 
    @IBOutlet weak var accX: UILabel!
    @IBOutlet weak var accY: UILabel!
    @IBOutlet weak var accZ: UILabel!
    var currentStep = 0
    var curr = 0
    var jay = 0
    //the pedometer
    var pedometer = CMPedometer()
    
    // timers
    var timer = Timer()
    var timerInterval = 1.0
    var timeElapsed:TimeInterval = 1.0
    
    
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    //MARK: - Outlets
    


    
    @IBAction func startStopButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start"{
            //Start the pedometer
            pedometer = CMPedometer()
            startTimer()
            pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
                if let pedData = pedometerData{
                    if (self.jay == 0){
                        self.numberOfSteps = Int(pedData.numberOfSteps)
                        self.currentStep=self.numberOfSteps
                        self.curr = self.currentStep
                        self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
                        self.jay=1
                    }
                    else{
                        self.numberOfSteps = Int(pedData.numberOfSteps)
                        self.curr=self.numberOfSteps-self.currentStep
                        self.currentStep = self.currentStep+self.curr
                        self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
                    }
                    } else {
                    self.numberOfSteps = nil
                    }
            })
            //Toggle the UI to on state
            statusTitle.text = "Pedometer On"
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = stopColor
        } else {
            //Stop the pedometer
            pedometer.stopUpdates()
            stopTimer()
            //Toggle the UI to off state
            statusTitle.text = "Pedometer Off: " + timeIntervalFormat(interval: timeElapsed)
            sender.backgroundColor = startColor
            sender.setTitle("Start", for: .normal)
        }
    }
    //MARK: - timer functions
    func startTimer(){
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
        displayPedometerData()
    }
    
    func timerAction(timer:Timer){
        displayPedometerData()
    }
    // display the updated data
    func displayPedometerData(){
        timeElapsed += 1.0
        statusTitle.text = "On: " + timeIntervalFormat(interval: timeElapsed)
        //Number of steps
        if let numberOfSteps = self.numberOfSteps{
            stepsLabel.text = String(format:"Steps: %i",numberOfSteps)
        }
        
        //distance
        
                //pace
    }
    
    //MARK: - Display and time format functions
    
    // convert seconds to hh:mm:ss as a string
    func timeIntervalFormat(interval:TimeInterval)-> String{
        var seconds = Int(interval + 0.5) //round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    // convert a pace in meters per second to a string with
    // the metric m/s and the Imperial minutes per mile
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if manager.isDeviceMotionAvailable{
            
            manager.deviceMotionUpdateInterval = 1.0
            manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { (data:CMDeviceMotion?, error:Error?) in
                self.accX?.text = "Acceleration x \(data!.userAcceleration.x)"
                self.accY?.text = "Acceleration y \(data!.userAcceleration.y)"
                self.accZ?.text = "Acceleration z \(data!.userAcceleration.z)"
                self.Direc.append(Int(data!.userAcceleration.y))
                self.Steps.append(self.curr)
                
            })
            
        }
    
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
