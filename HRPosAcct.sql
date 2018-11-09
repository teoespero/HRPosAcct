/*
	
	HRPosAcct
	The HRPosAcct table stores the account information for each position defined in the HRPos table.
*/

select 
	DistrictID,
	rtrim(DistrictAbbrev) as DistrictAbbrev,
	DistrictTitle
from tblDistrict

select 
	(select DistrictId from tblDistrict) as OrgId,
	pcd.SlotNum as PosID,
	null as PosTypeId,
	fund.fsAccountID as AcctNumID,
	acct.accountString,
	(select CONVERT(VARCHAR(10), StartDate, 110) from tblPayroll where PayrollID = fund.EffectivePayrollId) as DateFrom,
	null as DateThru,
	fund.[Percent]
from tblPositionControlDetails pcd
inner join
	tblJobTitles jt
	on pcd.pcJobTitleID = jt.JobTitleID
	and pcd.InactiveDate is null
inner join
	tblFundingSlotDetails fund
	on fund.fPositionControlID = pcd.PositionControlID
	and isnull(fund.Inactive,0) = 0
	and fund.InactivePayrollId is null
inner join
	tblAccount acct
	on fund.fsAccountID = acct.AccountID
order by
	fund.fPositionControlID asc
