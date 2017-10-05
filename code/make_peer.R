library(peer)
# from: https://github.com/PMBio/peer/wiki/Tutorial
# on 8/Dec/2016

make_peer	<- function(expr,K,X){

	model = PEER()

	if( ! missing(X) )
		PEER_setCovariates(model, as.matrix(X))

	PEER_setPhenoMean(model,as.matrix(expr))
	PEER_setNk(model,K)
	PEER_update(model)

	factors = PEER_getX(model)	# N x K
	if( ncol( factors ) > K ){
		if( is.matrix( X ) ){
			stop( 'X should not be a matrix in PEER' )
			factors	<- factors[,-(1:ncol(X))]
		} else {
			factors	<- factors[,-1]
		}
	}
	stopifnot( ncol( factors ) == K )

	return( as.matrix(factors) )

}
