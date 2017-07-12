clear all;

addpath('./Preprocessing');
addpath('./Localisation');
addpath('./tracking');
SAMPLES_PER_FRAME=128;
NB_MICROPHONES=6;
RAW_BUFFER_SIZE=SAMPLES_PER_FRAME*NB_MICROPHONES;
myParameters=ParametersLoadDefault();
myMicrophones=microphonesInit(NB_MICROPHONES);
myMicrophones=setup_microphone_positions_and_gains(myMicrophones,myParameters);
myPreprocessor=preprocessorInit(myParameters,myMicrophones);
myBeamformer = beamformerInit(myParameters,myMicrophones);
% myMixture=mixtureInit(myParameters);
audio_float_data=zeros(NB_MICROPHONES,SAMPLES_PER_FRAME);

[audio,fs]=audioread('./��Ƶ-all_02.wav');
[len1,len2] = size(audio);
audio_raw_data = reshape(audio',[len1*len2,1]);
nFrame=round(length(audio_raw_data)/(SAMPLES_PER_FRAME*NB_MICROPHONES));
frameNumber=1;
angle=[];
for frameNumber=1:nFrame-1
	fprintf('frameNumber,%d \n',frameNumber);
	for channel=1:NB_MICROPHONES
		audio_float_data(channel,:)=audio_raw_data(channel+NB_MICROPHONES*...
            (0:SAMPLES_PER_FRAME-1)+(frameNumber-1)*NB_MICROPHONES*SAMPLES_PER_FRAME);
        myPreprocessor=preprocessorPushFrames(myPreprocessor, SAMPLES_PER_FRAME, channel);
        myPreprocessor=preprocessorAddFrame(myPreprocessor,audio_float_data(channel,:),...
        channel, SAMPLES_PER_FRAME);
    end

    myPreprocessor=preprocessorProcessFrame(myPreprocessor);
%     //#3 Find potential sources from the beamformer
    myBeamformer=beamformerFindMaxima(myBeamformer, myPreprocessor);%, myPotentialSources);
    myBeamformer.maxIndexes
    myBeamformer.bestPoints(1,:)
    angle=[angle,atan(myBeamformer.bestPoints(1,1)/...
        myBeamformer.bestPoints(1,2))*180/pi];
    myBeamformer.maxValues;
end


function myMicrophones=setup_microphone_positions_and_gains(myMicrophones,parametersStruct)
	  myMicrophones=microphonesAdd(myMicrophones,1,...
                   parametersStruct.P_GEO_MICS_MIC1_X,...
                   parametersStruct.P_GEO_MICS_MIC1_Y,...
                   parametersStruct.P_GEO_MICS_MIC1_Z,...
                   parametersStruct.P_GEO_MICS_MIC1_GAIN...
                   );

%     // Add microphone 2...
    myMicrophones=microphonesAdd(myMicrophones,2,...
                   parametersStruct.P_GEO_MICS_MIC2_X,...
                   parametersStruct.P_GEO_MICS_MIC2_Y,...
                   parametersStruct.P_GEO_MICS_MIC2_Z,...
                   parametersStruct.P_GEO_MICS_MIC2_GAIN...
                   );

%     // Add microphone 3...
    myMicrophones=microphonesAdd(myMicrophones,3,...
                   parametersStruct.P_GEO_MICS_MIC3_X,...
                   parametersStruct.P_GEO_MICS_MIC3_Y,...
                   parametersStruct.P_GEO_MICS_MIC3_Z,...
                   parametersStruct.P_GEO_MICS_MIC3_GAIN...
                   );

%     // Add microphone 4...
    myMicrophones=microphonesAdd(myMicrophones,4,...
                   parametersStruct.P_GEO_MICS_MIC4_X,...
                   parametersStruct.P_GEO_MICS_MIC4_Y,...
                   parametersStruct.P_GEO_MICS_MIC4_Z,...
                   parametersStruct.P_GEO_MICS_MIC4_GAIN...
                   );

%     // Add microphone 5...
    myMicrophones=microphonesAdd(myMicrophones,5,...
                   parametersStruct.P_GEO_MICS_MIC5_X,...
                   parametersStruct.P_GEO_MICS_MIC5_Y,...
                   parametersStruct.P_GEO_MICS_MIC5_Z,...
                   parametersStruct.P_GEO_MICS_MIC5_GAIN...
                   );

%     // Add microphone 6...
    myMicrophones=microphonesAdd(myMicrophones,6,...
                   parametersStruct.P_GEO_MICS_MIC6_X,...
                   parametersStruct.P_GEO_MICS_MIC6_Y,...
                   parametersStruct.P_GEO_MICS_MIC6_Z,...
                   parametersStruct.P_GEO_MICS_MIC6_GAIN...
                   );

%     // Add microphone 7...
%     myMicrophones=microphonesAdd(myMicrophones,7,...
%                    parametersStruct.P_GEO_MICS_MIC7_X,...
%                    parametersStruct.P_GEO_MICS_MIC7_Y,...
%                    parametersStruct.P_GEO_MICS_MIC7_Z,...
%                    parametersStruct.P_GEO_MICS_MIC7_GAIN...
%                    );
% 
% %     // Add microphone 8...
%     myMicrophones=microphonesAdd(myMicrophones,8,...
%                    parametersStruct.P_GEO_MICS_MIC8_X,...
%                    parametersStruct.P_GEO_MICS_MIC8_Y,...
%                    parametersStruct.P_GEO_MICS_MIC8_Z,...
%                    parametersStruct.P_GEO_MICS_MIC8_GAIN...
%                    );


	function myMicrophones=microphonesAdd(myMicrophones,indexMic,x,y,z,gain)
		myMicrophones.micsPosition(indexMic,1)=x;
		myMicrophones.micsPosition(indexMic,2)=y;
		myMicrophones.micsPosition(indexMic,3)=z;
		myMicrophones.micsGain(indexMic)=gain;
	end
end
function myPreprocessor=preprocessorPushFrames(myPreprocessor, shiftSize, micIndex)
  myPreprocessor.micArray(micIndex).xtime(1:myPreprocessor.PP_FRAMESIZE - shiftSize)=myPreprocessor.micArray(micIndex).xtime(shiftSize+1:myPreprocessor.PP_FRAMESIZE);
end
function myPreprocessor=preprocessorAddFrame(myPreprocessor,newFrame,micIndex, sizeFrame)
     gain=myPreprocessor.myMicrophones.micsGain(micIndex);
     myPreprocessor.micArray(micIndex).xtime(myPreprocessor.PP_FRAMESIZE - sizeFrame+1:end)=gain*newFrame;
end



