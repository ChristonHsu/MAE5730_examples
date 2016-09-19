% Solve Handout 14 problem -- Rotation with zero angular momentum.
% 
%   See problem_statement.png
%
% Point labeling:
%
%        (3)
%         |
%         |
% (2) -------- (1)
%         |
%         |
%        (4)

clear all; close all;

% Setup variables
syms t m phi phidot theta thetadot real

% Plate rotation -- Counterclockwise rotation about the z (out of the
% page) axis
plateRot = [cos(phi) -sin(phi) 0 ; sin(phi) cos(phi) 0; 0 0 1];

%%%%% Points fixed to plate %%%%
p1 = plateRot*[0,2,0]'; % Rotate them from plate-frame to world-frame.
p2 = plateRot*[0,-2,0]'; 

v1 = jacobian(p1,phi)*phidot; % Chain rule to get velocity (in world frame)
v2 = jacobian(p2,phi)*phidot;

%%%%% Points moving on the plate %%%%
r = 1;

p3 = plateRot*([2, 0, 0]' + [r*cos(theta),r*sin(theta),0]'); % Add two vectors to get the position of the moving points in body frame, then transform the whole result to get fixed frame.
p4 = plateRot*([-2, 0, 0]' + [-r*cos(theta),-r*sin(theta),0]');

v3 = jacobian(p3,[t, phi, theta])*[1,phidot, thetadot]'; % Mass chain rule to get d/dt of the positions.
v4 = jacobian(p4,[t,phi, theta])*[1,phidot, thetadot]';

%%%%% Momentum %%%%%
h1 = cross(p1,m*v1);
h2 = cross(p2,m*v2);

h3 = cross(p3,m*v3);
h4 = cross(p4,m*v4);

phidot_inTheta = simplify(solve(h1 + h2 + h3 + h4, phidot)); % sum of H's == 0. Solve for phidot. This is in terms of theta, NOT time

% We are given expression for theta, we can take derivative.
theta = (1 - cos(t))*pi;
thetadot = jacobian(theta,t);

phidot_inTime = simplify(eval(phidot_inTheta)); % Re-evaluate the expression now that we have theta to plug in.

% Give results
fprintf('Expression for phidot in terms of theta and thetadot. \n\nphidot = \n\n');
pretty(phidot_inTheta);

fprintf('Expression for phidot in terms of theta and thetadot. \n\nphidot = \n\n');
pretty(phidot_inTime);

positions = eval([p1(1:2)',p2(1:2)',p3(1:2)',p4(1:2)']);

% Write two functions.
matlabFunction(positions,'file','positions');
matlabFunction(phidot_inTime,'file','phidot');


