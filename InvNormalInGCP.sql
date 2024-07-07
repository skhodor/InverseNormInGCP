BEGIN

--Find inverse normal x where the CDF equals 0.9 (i.e. F = 0.9), mean is 70, and standard deviation is 4.5
DECLARE F FLOAT64 DEFAULT 0.9;
DECLARE u FLOAT64 DEFAULT 70;
DECLARE sigma FLOAT64 DEFAULT 4.5;


DECLARE normsinv FLOAT64;
DECLARE k INT64;
DECLARE pi FLOAT64;
DECLARE inverf FLOAT64;
DECLARE twoFminusone FLOAT64;
DECLARE coefficients_k ARRAY<FLOAT64>;


SET coefficients_k = [1.0, 1.0, 1.6666666666666667, 1.41111111111111111112];

SET pi = ACOS(-1);
SET k = 0;
SET inverf = 0;
SET twoFminusone = 2*F-1;

WHILE k < ARRAY_LENGTH(coefficients_k) DO
	SET inverf = inverf+coefficients_k[OFFSET(k)]*POW(2, -1-2*k)*POW(pi, k+0.5)*POW(twoFminusone, 2*k+1)/(2*k+1);
  SET k = k+1;
END WHILE;

SET normsinv = u+sigma*SQRT(2)*inverf;
SELECT normsinv;

END;
