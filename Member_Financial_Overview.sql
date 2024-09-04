-- CTE for Holiday Amount Calculation
WITH New_Balance_CTE AS (
    SELECT
        ftt.mbr_auto,
        SUM(ftt.amt) + fmr.last_trn_bal AS total_amt
    FROM {fndtrn} ftt
    LEFT JOIN {fndmbr} fmr ON ftt.mbr_auto = fmr.mbr_auto
    LEFT JOIN {auth} au ON ftt.autoincr = au.trn_auto
    WHERE
        ftt.trn_status <> 'X'
        AND ftt.code_auto NOT IN (42, 11, 116)
        AND (au.status IS NULL OR au.status = 'F')
        AND ftt.fun_auto = 6
        AND fmr.fun_auto = 6
        AND ftt.trn_date BETWEEN fmr.[last_trn_date] AND GETDATE()
        AND ftt.[trn_date] BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
    GROUP BY
        ftt.mbr_auto, fmr.last_trn_bal
),

-- CTE for Retirement Amount Calculation
Max_Retirement_CTE AS (
    SELECT
        ft.mbr_auto,
        MAX(ft.autoincr) AS max_autoincr
    FROM {fndtrn} ft
    LEFT JOIN {fndmbr} fmr ON ft.mbr_auto = fmr.mbr_auto
    LEFT JOIN {auth} au ON ft.autoincr = au.trn_auto
    WHERE
        ft.fun_auto = 3 AND fmr.fun_auto = 3
        AND ft.trn_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
        AND (au.status IS NULL OR au.status = 'F')
    GROUP BY
        ft.mbr_auto
),

-- CTE for Provident Amount Calculation
Max_Provident_CTE AS (
    SELECT
        ftf.mbr_auto,
        MAX(ftf.autoincr) AS max_autoincr
    FROM {fndtrn} ftf
    LEFT JOIN {fndmbr} fmr ON ftf.mbr_auto = fmr.mbr_auto
    LEFT JOIN {auth} au ON ftf.autoincr = au.trn_auto
    WHERE
        ftf.fun_auto = 2 AND fmr.fun_auto = 2
        AND ftf.trn_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
        AND (au.status IS NULL OR au.status = 'F')
    GROUP BY
        ftf.mbr_auto
),

-- CTE for fndpay gcoss Amount Calculation
Max_Fndpay_CTE AS (
    SELECT
        fp.mbr_auto,
        MAX(fp.autoincr) AS max_autoincr
    FROM {fndpay} fp
    WHERE
        fp.fun_auto = 6
        AND fp.prepare_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
    GROUP BY
        fp.mbr_auto
),

-- CTE for fc Retirement Amount Calculation
Max_FC_Retirement_CTE AS (
    SELECT
        fcft.mbr_auto,
        MAX(fcft.autoincr) AS max_autoincr
    FROM {fndtrn} fcft
    LEFT JOIN {auth} au ON fcft.autoincr = au.trn_auto
    WHERE
        fcft.fun_auto = 3
        AND fcft.trn_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
        AND (au.status IS NULL OR au.status = 'F')
    GROUP BY
        fcft.mbr_auto
),

-- CTE for fc Provident Amount Calculation
Max_FC_Provident_CTE AS (
    SELECT
        fcftf.mbr_auto,
        MAX(fcftf.autoincr) AS max_autoincr
    FROM {fndtrn} fcftf
    LEFT JOIN {auth} au ON fcftf.autoincr = au.trn_auto
    WHERE
        fcftf.fun_auto = 2
        AND fcftf.trn_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
        AND (au.status IS NULL OR au.status = 'F')
    GROUP BY
        fcftf.mbr_auto
),

-- CTE for fc Home Loan Calculation
Max_FC_HomeLoan_CTE AS (
    SELECT
        h.mbr_auto,
        MAX(h.autoincr) AS max_autoincr
    FROM {fndtrn} h
    LEFT JOIN {auth} au ON h.autoincr = au.trn_auto
    WHERE
        h.fun_auto = 7
        AND h.trn_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
        AND (au.status IS NULL OR au.status = 'F')
    GROUP BY
        h.mbr_auto
),

-- CTE for Outstanding Amount Calculation
Outstanding_CTE AS (
    SELECT
        h.mbr_auto,
        MAX(h.autoincr) AS max_autoincr
    FROM {fndtrn} h
    LEFT JOIN {auth} au ON h.autoincr = au.trn_auto
    WHERE
        h.fun_auto = 7
        AND h.trn_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
        AND (au.status IS NULL OR au.status = 'F')
    GROUP BY
        h.mbr_auto
),

-- CTE for Prepared Amount Calculation
Prepared_CTE AS (
    SELECT
        p.mbr_auto,
        SUM(p.mbr_amt) as mbr_amt
    FROM {fndpay} p
    WHERE
        p.fun_auto = 6
        AND p.prepare_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31') 
        AND p.status = 'P'
        
    GROUP BY
        p.mbr_auto  
),

-- CTE for Paid Amount Calculation
Paid_CTE AS (
    SELECT
        p.mbr_auto,
        SUM(p.mbr_amt) as mbr_amt
    FROM {fndpay} p 
    WHERE
        p.fun_auto = 6
        AND p.finalise_date BETWEEN CONCAT((@SelectedYear-1),'-11-01') AND CONCAT(@SelectedYear,'-10-31')
        AND p.status = 'F'
        
    GROUP BY
        p.mbr_auto  
),

Bank_Details AS (
    SELECT 
        mc.[bank_hpay_yearno],
        mc.[bank],
        COALESCE(y.Type, '0') AS Type,
        mc.[bank_accno],
        mc.[bank_branchcode],
        mc.mbr_auto
    FROM {mbrcon} mc 
    LEFT JOIN {BankAccountType} y 
        ON TRY_CAST(mc.bank_acctype AS INT) = y.autoIncr
    GROUP BY 
        mc.[bank_hpay_yearno],
        mc.[bank],
        COALESCE(y.Type, '0'),
        mc.[bank_accno],
        mc.[bank_branchcode],
        mc.mbr_auto
)

-- Main Query
SELECT
    m.[autoincr],
    CASE
        WHEN LEN(m.[idno]) <> 0 THEN m.[idno]
        WHEN LEN(m.[passport]) <> 0 THEN m.[passport]
        ELSE m.[old_idno]
    END AS idNo,
    m.[surname],
    m.[firstnames],
    m.[initials],
    ROUND(MAX(ft.bal), 2) AS total_pens_amt,
    ROUND(MAX(ftf.bal), 2) AS total_prov_amt,
    (ROUND(COALESCE(MAX(New_Balance_CTE.total_amt), 0), 2)  + COALESCE(MAX(p.mbr_amt),0)) AS Holiday,
    -MAX(p.mbr_amt) AS Paid,
    -MAX(pr.mbr_amt) AS Prepared,
    ROUND(COALESCE(MAX(New_Balance_CTE.total_amt), 0), 2) AS Outstanding,
    bk.[bank_hpay_yearno],
    bk.[bank],
    bk.Type,
    bk.[bank_accno],
    bk.[bank_branchcode],
    '',
    ROUND(MAX(h.bal), 2) AS FC_HOMELOAN,
    ROUND(MAX(fcftf.bal), 2) AS FC_PROVIDENT,
    ROUND(MAX(fcft.bal), 2) AS FC_RETIREMET,
    (
        SELECT
            STUFF((
                SELECT ' ' + {cat}.category + 'x' + CAST(COUNT(*) AS VARCHAR)
                FROM {fndstp}
                LEFT JOIN {mem} ON {fndstp}.emp_auto = {mem}.autoincr
                LEFT JOIN {cat} ON {fndstp}.cat_auto = {cat}.autoincr
                WHERE {mem}.autoincr = m.autoincr AND {fndstp}.[yearno] = @SelectedYear
                GROUP BY {cat}.category 
                FOR XML PATH('')
            ), 1, 1, '')
    ) AS STAMPS
FROM
    {com} c
LEFT JOIN {emp} e ON c.autoincr = e.com_auto
LEFT JOIN {mem} m ON m.emp_auto = e.autoincr
LEFT JOIN {fndmbr} fm ON m.autoincr = fm.mbr_auto

-- Join with CTEs
LEFT JOIN New_Balance_CTE ON m.autoincr = New_Balance_CTE.mbr_auto
LEFT JOIN Max_Retirement_CTE max_ft ON m.autoincr = max_ft.mbr_auto
LEFT JOIN {fndtrn} ft ON (m.autoincr = ft.mbr_auto AND ft.autoincr = max_ft.max_autoincr)
LEFT JOIN Max_Provident_CTE max_ftf ON m.autoincr = max_ftf.mbr_auto
LEFT JOIN {fndtrn} ftf ON (m.autoincr = ftf.mbr_auto AND ftf.autoincr = max_ftf.max_autoincr)
LEFT JOIN Max_Fndpay_CTE max_fp ON m.autoincr = max_fp.mbr_auto
LEFT JOIN Max_FC_Retirement_CTE max_fcft ON m.autoincr = max_fcft.mbr_auto
LEFT JOIN {fndtrn} fcft ON (m.autoincr = fcft.mbr_auto AND fcft.autoincr = max_fcft.max_autoincr)
LEFT JOIN Max_FC_Provident_CTE fcmax_ftf ON m.autoincr = fcmax_ftf.mbr_auto
LEFT JOIN {fndtrn} fcftf ON (m.autoincr = fcftf.mbr_auto AND fcftf.autoincr = max_ftf.max_autoincr)
LEFT JOIN Max_FC_HomeLoan_CTE hmax_ft ON m.autoincr = hmax_ft.mbr_auto
LEFT JOIN {fndtrn} h ON (m.autoincr = h.mbr_auto AND h.autoincr = hmax_ft.max_autoincr)
LEFT JOIN Paid_CTE p ON m.autoincr = p.mbr_auto
LEFT JOIN Prepared_CTE pr ON m.autoincr = pr.mbr_auto
LEFT JOIN Bank_Details bk ON m.autoincr = bk.mbr_auto

WHERE
    c.[company_code] = @ComCode

GROUP BY
    m.[autoincr],
    m.[idno],
    m.[passport],
    m.[old_idno],
    m.[surname],
    m.[firstnames],
    m.[initials],
    bk.[bank_hpay_yearno],
    bk.[bank], 
    bk.Type, 
    bk.[bank_accno],
    bk.[bank_branchcode]

ORDER BY
    m.[surname]
OFFSET (@startIndex) ROWS 
FETCH NEXT 10 ROWS ONLY;
