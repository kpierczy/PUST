clear

G1T1 = dlmread('doc/report/data/exercise_3/step_responses/G1T1.txt');
G1T3 = dlmread('doc/report/data/exercise_3/step_responses/G1T3.txt');
G2T1 = dlmread('doc/report/data/exercise_3/step_responses/G2T1.txt');
G2T3 = dlmread('doc/report/data/exercise_3/step_responses/G2T3.txt');

G1T1 = G1T1(:, 2);
G1T3 = G1T3(:, 2);
G2T1 = G2T1(:, 2);
G2T3 = G2T3(:, 2);