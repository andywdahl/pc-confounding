library(iasva)

#based on https://cdn.rawgit.com/dleelab/iasvaExamples/d4d63ce3/inst/doc/tSNE_post_IA-SVA_3celltypes_iasvaV0.95.html
# mod <- model.matrix(~Patient_ID+Batch+Geo_Lib_Size)
# iasva.res<- iasva(t(counts), mod[,-1],verbose=FALSE, num.sv=5)
# I've not removed the intercept though

make_iasva <- function(expr,K,X,long=F){

	mod		<- model.matrix(~1+X)
	if( long ){
		out	<- iasva( expr, mod,	num.sv=K, B=50 )
	} else {
		out	<- iasva( expr, mod,	num.sv=K )
	}

	svs	<- out$sv
	if( all( svs == 0 ) & is.null(dim(svs)) )
		return( NA )

	svs

}
