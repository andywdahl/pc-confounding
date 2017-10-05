rm( list=ls() )
sink( 'ks_test_oneside_b.Rout' )

load( file='Rdata/pars.Rdata' )

all_savefile	<- paste0( 'ks_test_oneside_b.Rdata' )
if( file.exists(	all_savefile ) ){
	load(						all_savefile  )
} else {
	xx		<- array( NA,
		dim=c(				2,	a.n,2+K.n,								fac.n,		maxit		),
		dimnames=list(1:2,as,	c('ols', Ks, 'ice' ), factypes, 1:maxit	)
	)
}

ks_fxn	<- function(x,check=F){
	if( all( is.na(x) ) )
		return(NA)
	x			<- x[!is.na(x)]
	x			<- 10^(-x)
	if( length( unique(x) ) < length( x ) )
		if( check ){
			return( NA )
		} else {
			stop('strange...')
		}
	ks.test(x=x,y='punif',alternative='greater')$p.value
}


for( it in 1:maxit )
	for( a in 1:a.n )
{
	savefile	<- paste0( 'Rdata/ols', '_', a, '_', it, '.Rdata' )
	if( any( ! is.na( xx[1,a,'ols',,it] ) ) | ! file.exists( savefile ) )
		next
	cat( it , ' ' )
	load( savefile )

	xx[1,a,'ols',,it]	<- ks_fxn( x=out['pval',1,-caus_p] )

	rm( caus_p, out )

}
save( xx, file=all_savefile )

for( it in 1:maxit )
	for( a in 1:a.n )
{
	savefile	<- paste0( 'ice', '_', a, '_', it, '.Rdata' )
	if( any( ! is.na( xx[1,a,'ice',,it] ) ) | ! file.exists( savefile ) )
		next
	cat( it , ' ' )
	load( savefile )

	xx[1,a,'ice',,it]	<- ks_fxn( x=out		['pval',1,-caus_p], check=T )
	xx[2,a,'ice',,it]	<- ks_fxn( x=out_2	['pval',1,-caus_p], check=T )

	rm( caus_p, out, out_2 )
}
save( xx, file=all_savefile )

for( fac in factypes )
	for( it in 1:maxit )
		for( a in 1:a.n )
{
	savefile	<- paste0( 'Rdata/', fac, '_', a, '_', it, '.Rdata' )
	if( any( ! is.na( xx[1,a,1:K.n+1,fac,it] ) ) | ! file.exists( savefile ) )
		next
	cat( it , ' ' )
	load( savefile )

	if( ! all( is.na( out ) ) )
	xx[1,a,1:K.n+1,fac,it]	<- sapply( 1:K.n, function(K.i) ks_fxn( x=out		['pval',K.i,-caus_p] ) )
	if( ! all( is.na( out_2 ) ) )
	xx[2,a,1:K.n+1,fac,it]	<- sapply( 1:K.n, function(K.i) ks_fxn( x=out_2	['pval',K.i,-caus_p] ) )

	rm( caus_p, out, out_2 )
}
save( xx, file=all_savefile )

warnings()
