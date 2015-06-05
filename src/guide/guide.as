[Embed(source="tax.xml", mimeType="application/octet-stream")]
private const tax_xml:Class;
[Embed(source="useSkill.xml", mimeType="application/octet-stream")]
private const useSkill_xml:Class;

private function initXML():void
{
	xml = <guide></guide>;
	xml = xml.appendChild(XML((new tax_xml()).toString())).
		appendChild(XML((new useSkill_xml()).toString()));
	
}

