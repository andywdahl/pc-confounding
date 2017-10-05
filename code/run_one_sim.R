run_one_sim	<- function( Y, g, Ks, Z, nomean=FALSE ){
	P	<- ncol(Y)
	out	<- array( NA,
		dim=c(					3,											length(Ks),	P ),
		dimnames=list(	c('beta','sd','pval'),	Ks,		1:P )
	)
	for( p in 1:P )
		out[,,p]	<- test_one_phen( Y[,p], g, Ks, Z, nomean=nomean )
	return( out )
}

test_one_phen	<- function( y, g, Ks, Z, nomean ){
	if( is.null( Z ) ){

		summs	<- array( NA,
			dim=c(				3		,	length(Ks)),
			dimnames=list(1:3	, Ks				)
		)
		if( !nomean ){
			summs[,1]	<- loc_summ_fxn( y ~ g )
		} else {
			summs[,1]	<- loc_summ_fxn( y ~ g - 1, coefid=1 )
		}

	} else {

		summs		<- sapply( Ks, function(K){
			if( K > ncol(Z) ){
				rep( NA, 3 )
			} else {
				if( !nomean ){
					loc_summ_fxn( y ~ g + Z[,1:K] )
				} else {
					loc_summ_fxn( y ~ g + Z[,1:K] - 1, coefid=1 )
				}
			}
		})

	}
	summs
}

loc_summ_fxn	<- function( expr, coefid=2 ){
	coeffs	<- summary( lm( expr ) )$coef[coefid,]
	c( coeffs[1], coeffs[2], -log10( coeffs[4] ) )
}
