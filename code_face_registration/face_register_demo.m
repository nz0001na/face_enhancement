      eyes.x(1)=33;  %These coordinates were obtained using getpts(),
      eyes.y(1)=100;  %but could also be read from a file
      eyes.x(2)=85;
      eyes.y(2)=95;
      X=imread('0001_A.jpg');
      Y = register_face_based_on_eyes(X,eyes,[128 100]);
      figure,imshow(X,[]);
      impixelinfo
      figure,imshow(uint8(Y),[]);