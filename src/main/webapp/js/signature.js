/**
 * arguments[0]	= canvas object
 * */
var SignatureLeftMButtonDown	= false;
var SignatureIsSign				= false;
function Signature(){
	this.canvasElement		= arguments[0];
	SignatureIsSign				= false;
	SignatureLeftMButtonDown	= false;
	this.imgData			= null;
	this.canvasWidth		= 300;
	this.canvasHeight		= 100;
	
	this.init_Sign_Canvas	= function() {
		SignatureIsSign = false;
		SignatureLeftMButtonDown = false;
		//Set Canvas width
		this.canvasElement.width(this.canvasWidth);
		this.canvasElement.height(this.canvasHeight);
		//this.canvasElement.css("border","1px solid #bebebe");
		
		var canvas = this.canvasElement.get(0);
		
		 canvasContext = canvas.getContext('2d');
		 canvasContext.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
		 canvasContext.lineCap = 'round';
		 
		 if(canvasContext){
			 canvasContext.canvas.width  = this.canvasWidth;
			 canvasContext.canvas.height = this.canvasHeight;
		 }
		 // Bind Mouse events
		 $(canvas).on('mousedown', function (e) {
			 if(e.which === 1) { 
				 SignatureLeftMButtonDown = true;
				 canvasContext.fillStyle = "#000";
				 var x = e.pageX - $(e.target).offset().left;
				 var y = e.pageY - $(e.target).offset().top;
				 canvasContext.moveTo(x, y);
			 }
			 e.preventDefault();
			 return false;
		 });
		
		 $(canvas).on('mouseup', function (e) {
			 if(SignatureLeftMButtonDown && e.which === 1) {
				 SignatureLeftMButtonDown = false;
				 SignatureIsSign = true;
			 }
			 e.preventDefault();
			 return false;
		 });
		
		 // draw a line from the last point to this one
		 $(canvas).on('mousemove', function (e) {
			 if(SignatureLeftMButtonDown == true) {
				 canvasContext.fillStyle = "#000";
				 var x = e.pageX - $(e.target).offset().left;
				 var y = e.pageY - $(e.target).offset().top;
				 canvasContext.lineWidth = 5;
				 canvasContext.lineTo(x,y);
				 canvasContext.stroke();
			 }
			 e.preventDefault();
			 return false;
		 });
		 
		 //bind touch events
		 $(canvas).on('touchstart', function (e) {
			SignatureLeftMButtonDown = true;
			canvasContext.fillStyle = "#000";
			var t = e.originalEvent.touches[0];
			var x = t.pageX - $(e.target).offset().left;
			var y = t.pageY - $(e.target).offset().top;
			canvasContext.moveTo(x, y);
			
			e.preventDefault();
			return false;
		 });
		 
		 $(canvas).on('touchmove', function (e) {
			canvasContext.fillStyle = "#000";
			var t = e.originalEvent.touches[0];
			var x = t.pageX - $(e.target).offset().left;
			var y = t.pageY - $(e.target).offset().top;
			canvasContext.lineWidth = 5;
			canvasContext.lineTo(x,y);
			canvasContext.stroke();
			
			e.preventDefault();
			return false;
		 });
		 
		 $(canvas).on('touchend', function (e) {
			if(SignatureLeftMButtonDown) {
				SignatureLeftMButtonDown = false;
				SignatureIsSign = true;
			}
		 });
	};
	
	this.completeSignature	= function() {
		if(SignatureIsSign) {
			this.imgData = this.canvasElement.get(0).toDataURL("image/png");
			return true;
		}else{
			alert('서명이 작성되지 않았습니다.',"알림",'b');
			return false;
		}
	};
	this.getImageData	= function(){
		return this.imgData;
	};
	this.getWidth	= function(){
		return this.canvasWidth;
	};
	this.getHeight	= function(){
		return this.canvasHeight;
	};
}


