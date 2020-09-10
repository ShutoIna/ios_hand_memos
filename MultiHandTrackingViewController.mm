// Copyright 2019 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MultiHandTrackingViewController.h"

#include "mediapipe/framework/formats/landmark.pb.h"

static const char* kLandmarksOutputStream = "multi_hand_landmarks";

//以下追加
//static NSString *pth = @"~/Documents";

static NSString * pth01 = (NSString *)
[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                     NSUserDomainMask,
                                     YES) lastObject];

//h=hand_indexです．0=左手, 1=右手
//i=indexです． 0-20の21点の座標
//x,y,z=21点のxyz座標
//t=time

//各情報を格納するpath及びcsvファイル
static NSString *pth_t = [pth01 stringByAppendingPathComponent:@"test_t.csv"];
static NSString *pth_h = [pth01 stringByAppendingPathComponent:@"test_h.csv"];
static NSString *pth_i = [pth01 stringByAppendingPathComponent:@"test_i.csv"];
static NSString *pth_x = [pth01 stringByAppendingPathComponent:@"test_x.csv"];
static NSString *pth_y = [pth01 stringByAppendingPathComponent:@"test_y.csv"];
static NSString *pth_z = [pth01 stringByAppendingPathComponent:@"test_z.csv"];

//csvに入れるための文字ファイル
static  NSMutableString* mstr_t = [[NSMutableString alloc] init];
static  NSMutableString* mstr_h = [[NSMutableString alloc] init];
static  NSMutableString* mstr_i = [[NSMutableString alloc] init];
static  NSMutableString* mstr_x = [[NSMutableString alloc] init];
static  NSMutableString* mstr_y = [[NSMutableString alloc] init];
static  NSMutableString* mstr_z = [[NSMutableString alloc] init];

 //static NSSavePanel *panel = [NSSavePanel savePanel];
// セーブ・パネルを取得
 // セーブ・パネルを表示

static NSString *filePath = @"/Users/inagakishuto/Desktop/test.csv";
static NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//以上追加

@implementation MultiHandTrackingViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.mediapipeGraph addFrameOutputStream:kLandmarksOutputStream
                           outputPacketType:MPPPacketTypeRaw];
}

#pragma mark - MPPGraphDelegate methods

// Receives a raw packet from the MediaPipe graph. Invoked on a MediaPipe worker thread.
- (void)mediapipeGraph:(MPPGraph*)graph
     didOutputPacket:(const ::mediapipe::Packet&)packet
          fromStream:(const std::string&)streamName {
  if (streamName == kLandmarksOutputStream) {
    if (packet.IsEmpty()) {
      NSLog(@"[TS:%lld] No hand landmarks", packet.Timestamp().Value());
      return;
    }
    const auto& multi_hand_landmarks = packet.Get<std::vector<::mediapipe::NormalizedLandmarkList>>();
    NSLog(@"[TS:%lld] Number of hand instances with landmarks: %lu", packet.Timestamp().Value(),
          multi_hand_landmarks.size());
      //以下一文追加
      NSDate*currentDate=[NSDate date];
    for (int hand_index = 0; hand_index < multi_hand_landmarks.size(); ++hand_index) {
      const auto& landmarks = multi_hand_landmarks[hand_index];
      NSLog(@"\tNumber of landmarks for hand[%d]: %d", hand_index, landmarks.landmark_size());
      for (int i = 0; i < landmarks.landmark_size(); ++i) {
        NSLog(@"\t\tLandmark[%d]: (%f, %f, %f)", i, landmarks.landmark(i).x(),
              landmarks.landmark(i).y(), landmarks.landmark(i).z());
          //以下追加
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                             // フォーマットを指定の日付フォーマットに設定
                             [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
                             // 日付型の文字列を生成
                 NSString *str_t = [dateFormatter stringFromDate:currentDate];

                 NSString *str_h = [NSString stringWithFormat:@"%d", hand_index];
                 NSString *str_i = [NSString stringWithFormat:@"%d", i];
                 NSString *str_x = [NSString stringWithFormat:@"%f", landmarks.landmark(i).x()];
                 NSString *str_y = [NSString stringWithFormat:@"%f", landmarks.landmark(i).y()];
                 NSString *str_z = [NSString stringWithFormat:@"%f", landmarks.landmark(i).z()];

                   [mstr_t appendString:@"\n"];
                   [mstr_t appendString:str_t];
                   
                   [mstr_h appendString:@"\n"];
                   [mstr_h appendString:str_h];

                   [mstr_i appendString:@"\n"];
                   [mstr_i appendString:str_i];
                   
                   [mstr_x appendString:@"\n"];
                   [mstr_x appendString:str_x];
                   
                   [mstr_y appendString:@"\n"];
                   [mstr_y appendString:str_y];
                   
                   [mstr_z appendString:@"\n"];
                   [mstr_z appendString:str_z];
               
             }
           }
               NSData* out_data_t = [mstr_t dataUsingEncoding:NSUTF8StringEncoding];
               [out_data_t writeToFile: pth_t atomically:NO];
               
               NSData* out_data_h = [mstr_h dataUsingEncoding:NSUTF8StringEncoding];
               [out_data_h writeToFile: pth_h atomically:NO];
               
               NSData* out_data_i = [mstr_i dataUsingEncoding:NSUTF8StringEncoding];
               [out_data_i writeToFile: pth_i atomically:NO];
               
               NSData* out_data_x = [mstr_x dataUsingEncoding:NSUTF8StringEncoding];
               [out_data_x writeToFile: pth_x atomically:NO];
               
               NSData* out_data_y = [mstr_y dataUsingEncoding:NSUTF8StringEncoding];
               [out_data_y writeToFile: pth_y atomically:NO];
               
               NSData* out_data_z = [mstr_z dataUsingEncoding:NSUTF8StringEncoding];
               [out_data_z writeToFile: pth_z atomically:NO];
      
    //以上追加
  }
}

@end
