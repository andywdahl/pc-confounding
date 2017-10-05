library(sva)

make_sva <- function(expr,K,X,irw=F,long=F,vlong=F){

	mod0	<- model.matrix(~1,	data=data.frame(expr) )

	if( !missing( X ) ){
		mod		<- model.matrix(~1+X, data=data.frame(expr) )
		if( long ){
			out	<- sva( dat=t(expr), mod=mod,	n.sv=K, mod0=mod0	,method="irw", B=50   )
		} else if( vlong ){
			out	<- sva( dat=t(expr), mod=mod,	n.sv=K, mod0=mod0	,method="irw", B=500  )
		} else {
			out	<- sva( dat=t(expr), mod=mod,	n.sv=K, mod0=mod0	,method="irw"  )
		}
	} else if( irw ){
		out	<- sva( dat=t(expr), mod=mod0,n.sv=K,	mod0=NULL	,method="irw" )
	} else {
		out	<- sva( dat=t(expr), mod=mod0,n.sv=K,						method="two-step" )
	}

	svs	<- out$sv
	if( all( svs == 0 ) & is.null(dim(svs)) )
		return( NA )

	svs

}
