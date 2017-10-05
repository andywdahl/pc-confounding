mainfxn	<- function( fac, meta, g, K, x ){
	Z			<- NULL
	if( fac == 'peer' ){
		if( meta == 1 ){
			Z	<- make_peer(Y, K=K			)
		} else {
			Z	<- make_peer(Y, K=K, X=g	)
		}
	} else if( fac == 'dummy' & meta == 1 ){
		print( 'moving through' )
	} else if( fac == 'suporacle' ){
		if( meta == 1 ){
			rm( Y )
			load( '../geuvadis/processed_data/Y_final.Rdata' )
			Z	<- cbind( x, svd( Y )$u[,1:K] )
		} else {
			Z		<- as.matrix( x )
		}
	} else if( fac == 'oracle' ){
		if( meta == 2 ){
			rm( Y )
			load( '../geuvadis/processed_data/Y_final.Rdata' )
			Z	<- svd( Y )$u[,1:K]
		}
	} else if( fac == 'pca' ){
		if( meta == 1 ){
			Z		<- svd( Y )$u
		} else {
			proj	<- diag(length(g)) - g%o%g/sum( g^2 )
			Z			<- svd( proj %*% Y )$u
		}
	} else if( fac == 'sva' ){
		if( meta == 1 & fac == 'sva' ){
			Z		<- make_sva( Y, K=K )
		} else if( meta == 2 ){
			Z		<- make_sva( Y, K=K, X=g )
		}
	} else if( fac %in% c( 'smartsva' ) ){
		if( meta == 1 ){
			stop()
		} else {
			Z		<- make_smartsva( Y, K=K, X=g )
		}
	} else if( fac %in% c( 'iasva' ) ){
		if( meta == 1 ){
			stop()
		} else {
			Z		<- make_iasva( Y, K=K, X=g )
		}
	} else {
		stop( fac )
	}
	if( K == 1 & !is.null(Z) )
		Z	<- as.matrix(Z)
	Z
}
