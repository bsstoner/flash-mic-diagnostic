package {

  import flash.display.Sprite;
  import flash.media.Microphone;
	import flash.events.*;

  public class MicTest extends Sprite {

    private const NUM_FRAMES_TO_RUN:int = 15;

    private var mic:Microphone;

    private var frameNum:int = 0;
    private var lastFrameTime:Number = 0;

    public function MicTest() {
      mic = Microphone.getMicrophone();

      txt_microphoneName.text = mic.name;
      txt_microphoneRate.text = mic.rate.toString();

      btn_run.addEventListener( MouseEvent.CLICK, onRunClick );
    }

    private function turnOnMic():void {
      mic.setSilenceLevel(0,1);
      mic.gain = 99;

      mic.addEventListener( SampleDataEvent.SAMPLE_DATA, onMicSampleData );
    }

    private function turnOffMic():void {
      mic.removeEventListener( SampleDataEvent.SAMPLE_DATA, onMicSampleData );
    }

    private function onRunClick( event:MouseEvent ):void {
      mic.rate = parseInt( txt_microphoneRate.text );

      frameNum = 0;
      lastFrameTime = 0;

      txt_samplesPerFrame.text = '';
      txt_timeSinceLastFrame.text = '';
      txt_frameNum.text = '';

      turnOnMic();
    }

    private function onMicSampleData( event:SampleDataEvent ):void {
      var t:Number = new Date().getTime();
      var numSamplesInFrame:int = event.data.length / 4;
      var timeSinceLastFrame:int = (lastFrameTime) ? t - lastFrameTime : 0;

      frameNum++;

			txt_samplesPerFrame.appendText( numSamplesInFrame + '\n' );

      txt_timeSinceLastFrame.appendText( timeSinceLastFrame + '\n' );

      txt_frameNum.appendText( frameNum + '\n' );

      // for next frame:
      lastFrameTime = t;

      // see if test is done:
      if(frameNum >= NUM_FRAMES_TO_RUN){
        turnOffMic();
      }
    }
  }
}
