unit uSomeTests;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestSomething = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TTestSomething.Setup;
begin
end;

procedure TTestSomething.TearDown;
begin
end;

procedure TTestSomething.Test1;
begin
end;

procedure TTestSomething.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestSomething);
end.
