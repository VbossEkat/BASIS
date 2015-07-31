SET STEP ON 
oXMLadapter2 = NEWOBJECT('xmladapter') 
oXMLadapter2.RespectNesting = .t.
oXMLAdapter2.XMLSchemaLocation= "1" &&'myxmlfile.xsd'
x = oXMLAdapter2.LoadXML('D:\Develop\Work\Basis\2.xml',.T.,.T.) 
WAIT WINDOW '1'
