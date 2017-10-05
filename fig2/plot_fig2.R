rm( list=ls() )
load( file='Rdata/pars.Rdata' )
load(	file='Rdata/ks_test_oneside_b.Rdata' )

ks_fxn	<- function(x){
	if( all( is.na(x) ) )
		return(NA)
	x	<- x[!is.na(x)]
	p	<- ks.test(x=x,y='punif')$p.value
	p	<- format( p, digits=0, nsmall=3, scientific=F )
	if( p < 1e-3 )
		p	<- '< .001'
	p
}

mainfxn	<- function(fac,sup){
	if( fac == 'sva' ){
		tmp	<- 'SVA'
	} else if( fac == 'peer' ){
		tmp	<- 'PEER'
	} else if( fac == 'pc' ){
		tmp	<- 'PCA'
	}
	if( sup == 1 ){
		tmp	<- paste( 'Unsup.', tmp )
	} else {
		tmp	<- paste( 'Sup.', tmp )
	}
	tmp
}


pdf( '~/figs/fig2a.pdf', width=11, height=4.9 )
layout( matrix( 1:(1*3), 1, 3 ), widths=c( 4.7, 4, 4 ) )

for( dum in 1:3 ){

	if( dum == 1 ){
		y	<- xx[1,,1,1,]
		main	<- 'OLS (K=0)'
	} else if( dum == 2 ){
		y	<- xx[1,,2+K.n,1,]
		main	<- 'ICE, ML'
	} else if( dum == 3 ){
		y	<- xx[2,,2+K.n,1,]
		main	<- 'ICE, REML'
	} else {
		stop()
	}

	atleft<- dum==1

	par( mar=c( 6, ifelse( atleft, 6, 0 ), 6, 0 ) )

	plot( 0:1, 0:1, type='n', main='', xlab='', ylab='', axes=F )
	box()
	axis( side=1, at=0:5/5	, lab=c( '0', '.2', '.4', '.6', '.8', '1' ) )
	mtext(side=1, line=4		, text='Expected p-value', cex=1.7 )
	mtext(side=3, line=2		, text=main, cex=1.5*1.5 )
	if( atleft ){
		axis( side=2, at=0:5/5	, lab=c( '0', '.2', '.4', '.6', '.8', '1' ) )
		mtext(side=2, line=3		, text='Observed p-value', cex=1.7 )
	}
	abline( a=0, b=1, col='grey', lwd=2, lty=2 )

	ks_ks	<- numeric()
	for( a in 1:4 ){
		loc_it	<- length( sort( y[a,] ) )
		if( loc_it == 0 )
			next
		ks_ks[a]	<- ks_fxn( y[a,] )
		lines( 1:loc_it/(1+loc_it), sort( y[a,] ), col=a )
	}
	legloc	<- ifelse( dum == 1, 'topleft', 'bottomright' )
	legend( legloc, fill=1:4, leg=ks_ks, cex=2.2 )

}
dev.off()







pdf( '~/figs/fig2b.pdf', width=24, height=10 )
layout( matrix( 1:(2*5), 2, 5 ), widths=c( 5, 4, 4, 4, 4 ), heights=c( 5, 5 ) )

for( sup in 1:2 )
	for( fac in factypes )
		for( kk in c( 2, 5 ) )
{

	if( fac == 'sva' & sup == 1 ) next

	attop	<- kk==2
	atleft<- fac==factypes[1] & sup == 1

	par( mar=c(
		ifelse( attop	, 0, 8 ),
		ifelse( atleft, 11, 0 ),
		ifelse( attop	, 8, 0 ),
		0
	))

	plot( 0:1, 0:1, type='n', main='', xlab='', ylab='', axes=F )
	box()
	if( !attop ){
		axis( side=1, at=0:5/5	, lab=c( '0', '.2', '.4', '.6', '.8', '1' ), cex.axis=2, padj=1 )
		mtext(side=1, line=6		, text='Expected p-value', cex=2.3 )
	} else {
		mtext(side=3, line=2		, text=mainfxn( fac, sup ), cex=1.5*2.3 )
	}
	if( atleft ){
		axis( side=2, at=0:5/5	, lab=c( '0', '.2', '.4', '.6', '.8', '1' ), cex.axis=2 )
		mtext(side=2, line=4.7	, text='Observed p-value'				, cex=2.3 )
		mtext(side=2, line=8		, text=paste( 'K =', Ks[kk-1] )	, cex=2.3 )
	}
	abline( a=0, b=1, col='grey', lwd=2, lty=2 )

	ks_ks	<- numeric()
	for( a in 1:4 ){
		loc_it	<- length( sort( xx[sup,a,kk,fac,] ) )
		if( loc_it == 0 )
			next
		ks_ks[a]	<- ks_fxn( xx[sup,a,kk,fac,1:loc_it] )
		lines( 1:loc_it/(1+loc_it), sort( xx[sup,a,kk,fac,] ), col=a )
	}
	legloc	<- ifelse( fac == 'peer' & sup == 1, 'bottomright', 'topleft' )
	legend( legloc, fill=1:4, leg=ks_ks, cex=2.8 )

}
dev.off()
