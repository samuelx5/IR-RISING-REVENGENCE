clf;
clc;
trOrigin = eye(4)
%x1 = transl(0,0,10)
x1 = transl(0,0,-8)



%Brandon change
tranimate(trOrigin,x1)
%x2 = x1*trotx(-30*pi/180)
x2 = transl(6,6,13)*x1
tranimate(x1,x2)
%x3 = transl(0,2,0)*x2
x3 = transl(-5,3,-2)*x2
tranimate(x2,x3)
%grounds = inv(x3)*x3*trotx(-30*pi/180)
%tranimate(x3,grounds)
%x4 = grounds*troty(30*pi/180)
%tranimate(grounds,x4)


