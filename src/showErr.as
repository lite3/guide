package  
{
	/**
	 * ...
	 * @author lite3
	 */
	public function showErr(err:Error):void
	{
		var s:String = err.getStackTrace();
		trace(s);
	}

}