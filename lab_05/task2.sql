USE MetroDB
GO

-- OPENXML

DECLARE @docid int
DECLARE @doc xml = '
<ROOT>
<Workers>
  <Name>��������� ����� ������������</Name>
  <Job>���������� ����-��������</Job>
  <Phone_Number>+79174518624</Phone_Number>
</Workers>
<Workers>
  <Name>������ ���� ��������</Name>
  <Job>�������� �� �������</Job>
  <Phone_Number>+79076313360</Phone_Number>
</Workers>
<Workers>
  <Name>������� ������ �����������</Name>
  <Job>������������</Job>
  <Phone_Number>+79866846025</Phone_Number>
</Workers>
<Workers>
  <Name>�������� ������� ���������</Name>
  <Job>�������-�������������</Job>
  <Phone_Number>+79145988862</Phone_Number>
</Workers>
<Workers>
  <Name>�������� ����� ����������</Name>
  <Job>������������</Job>
  <Phone_Number>+79063289327</Phone_Number>
</Workers>
</ROOT>'
EXEC sp_xml_preparedocument @docid output, @doc

SELECT *
FROM OPENXML(@docid, N'/ROOT/Workers', 2)
WITH (Name nvarchar(100), Job nvarchar(50), Phone_Number nvarchar(12))

EXEC sp_xml_removedocument @docid
GO

--- OPENROWSET

DECLARE @docid int
DECLARE @doc xml
SELECT @doc = C FROM OPENROWSET(BULK 'D:\Programming\education\DataBases\lab_05\task2.xml', SINGLE_BLOB) AS TEMP(C)
EXEC sp_xml_preparedocument @docid output, @doc

SELECT *
FROM OPENXML(@docid, N'/ROOT/Workers', 2)
WITH (Name nvarchar(100), Job nvarchar(50), Phone_Number nvarchar(12))

EXEC sp_xml_removedocument @docid
GO