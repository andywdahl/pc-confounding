library(SmartSVA)

make_smartsva <- function(expr,K,X){

	mod0 <- model.matrix(~1, data=data.frame(expr))

	if (!missing(X)) {
		mod	<- model.matrix(~1+X, data=data.frame(expr))

	} else {
		mod	<- mod0
		mod0 <- NULL
	}

	out	<- smartsva.cpp( dat=t(expr), n.sv=K, mod=mod,	mod0=mod0)

	svs	<- out$sv

	if(all( svs == 0 ) & is.null(dim(svs)))
		return(NA)

	svs

}
