library(phenix)
sim_fxn	<- function( seed, sig2_x, sig2_u, rho, f, dat_type ){
	load( '../geuvadis/processed_data/Y_final.Rdata' )

	set.seed( seed )
	if( dat_type == 'real' ){
		Y	<- scale(Y)
	} else if( dat_type == 'white' ){
		Y	<- matrix( rnorm( N*P ), N, P )
	} else if( dat_type == 'whitex2' ){
		N	<- 2*N
		Y	<- matrix( rnorm( N*P ), N, P )
	} else {
		stop( dat_type )
	}
	Y	<- sqrt(1-sig2_x-sig2_u) * Y
	
	ncaus	<- round( f * P )
	caus	<- sample( P, ncaus, replace=F )
	beta_x<- sqrt(P/ncaus)*rnorm( ncaus )

	beta_u<-	rnorm( P )

	Sigma	<- matrix( c( 1, sqrt(rho), sqrt(rho), 1 ), 2, 2 )
	xu		<- matrix( rnorm(N*2), N, 2 ) %*% mat.sqrt( Sigma )

	Y[,caus]	<- Y[,caus] + sqrt(sig2_x) * xu[,1] %o% beta_x
	Y					<- Y				+ sqrt(sig2_u) * xu[,2] %o% beta_u
	Y					<- scale( Y )

	is	<- sample( N, round(N/2) )

	list( g=xu[,1], x=xu[,2], caus=caus, Y=Y, N=N, is=is )

}
