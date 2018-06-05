myObj = VideoWriter('test.avi');
writerObj.FrameRate = 30;
open(myObj);
for i = 0:0.01:1
    frame = imread([num2str(i) '.jpg']);
    writeVideo(myObj,frame);
end
close(myObj);