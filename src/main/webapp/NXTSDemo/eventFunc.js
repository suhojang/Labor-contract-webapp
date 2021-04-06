function justTab(id, start, max)
{
	for(var i = start; i <= max; i++){
		hidtxtid = "txt" + i;
		document.all[hidtxtid].style.display='none';
	}
	var txtid = "txt" + id;
	
	if (document.all[txtid].style.display == 'block')
	{
		document.all[txtid].style.display='none';
	}
	else
	{
		document.all[txtid].style.display='block';
	}
}
