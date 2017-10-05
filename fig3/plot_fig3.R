rm( list=ls() )
load( 'Rdata/pars.Rdata' )
source( '../fig4/plot_fxns.R' )

panelfxn	<- function( y, ylim, add.ylab, logy, tol, ... ){
	plot( range(Ks), ylim, type='n', axes=F, xlab='', ylab='', ... )
	box()
	axis( 1, cex.axis=1.8, at=c(1,5,10,20) )
	mtext( side=1, '# Factors', line=4.5, cex=1.7 )
	if( add.ylab )
		if( logy ){
			ylabs	<- round( 10^seq(-2,0,len=5), 2 )
			axis( 2, cex.axis=1.5, at=log10( ylabs ), lab=ylabs )
		} else {
			axis( 2, cex.axis=1.5 )
		}
	for( i in 1:2 )
		abline( h=y[i,'ice',1], col=cols['ice'], lty=i, lwd=3.4 )

	fac	<- 'oracle'
	i		<- 1
			pointline(Ks, y[i,fac,], col=cols[fac], pch=16, lty=1 )
	for( i in 1:2 )
		for( fac in c( 'pca', 'iasva', 'peer', 'sva', 'smartsva' ) )
			pointline(Ks, y[i,fac,], col=cols[fac], pch=c(1,16)[i], lty=3-i )
}

plotfxn	<- function( pdfname, y, log=F, TP=F, ylim=0:1 ){

	pdf( pdfname, width=16, height=5 )
	layout( matrix( 1:5, 1, 5 ), widths=c(1.0,6,6,6,2.0) )
	par( mar=c( 6.5, 0, 5, 0 ) )

	ylab	<- 'False Positive Rate'
	if( log ){
		y			<- log10( y )
	} else if( TP ){
		ylab	<- 'True Positive Rate'
	}

	plot.new()
	mtext( side=2, line=-2, cex=1.7, ylab )

	for( type in types ){
		if( type == 'base' ){
			xx	<- 'Small, sparse '
		} else if( type == 'densest' ){
			xx	<- 'Small, dense '
		} else if( type == 'higher' ){
			xx	<- 'Large, sparse '
		}
		panelfxn( y[type,,,], add.ylab=(type=='base'), ylim=ylim, logy=log,
			main=substitute( paste(  xx, alpha ), list( xx=xx ) ), cex.main=3 )
	}

	par( mar=c( 6.5, 0, 5, 0 ) )
	plot.new()
	legend( 'topleft'			, cex=1.7, leg=c('PCA','PEER','SVA','SmartSVA','Unsup','Sup'), col=c( cols[c('pca','peer','sva','smartsva')], 1, 1 ), lty=c(rep(NA,4),2,1), pch=c(rep(15,4),1,16), pt.cex=c(2,2,2,2,1,1), bty='n')
	if( ylab=='True Positive Rate' ){
		legend( 'bottomleft', cex=1.7, leg=c('None','Oracle','Oracle+','ICE (REML)','ICE (ML)'), lty=c(1,2,1,2,1)	, pch=c(16,1,16,1,16)	, col=c(1,6,6,'orange','orange'), bty='n' )
	} else {
		if( log ){
		legend( 'bottomleft', cex=1.7, leg=c('None','Oracle'					), lty=c(1,1)		, pch=c(16,16)		, col=c(1,6), bty='n' )
		} else {
		legend( 'bottomleft', cex=1.7, leg=c('None','Oracle'					,'ICE (REML)','ICE (ML)'), lty=c(1,1,2,1)		, pch=c(16,16,1,16)		, col=c(1,6,	'orange','orange'), bty='n' )
		}
	}

	dev.off()
}

load( paste0( 'Rdata/psums_', .01, '_new.Rdata' ) )
print( nruns )
plotfxn( '~/figs/fig3.pdf'		, psums['FP',,,,], ylim=c(-2.2,0), log=T )
plotfxn( '~/figs/sfig4.pdf'		, psums['FP',,,,] )
plotfxn( '~/figs/sfig5.pdf'		, qsums['TP',,,,], TP=T   )
plotfxn( '~/figs/sfig6.pdf'		, qsums['FP',,,,] )
plotfxn( '~/figs/sfig6log.pdf', qsums['FP',,,,], log=T, ylim=c( -3.2, 0 ) )
rm( psums, qsums )

load( paste0( 'Rdata/psums_', .001, '_new.Rdata' ) )
plotfxn( '~/figs/sfig7.pdf'	, psums['FP',,,,], log=T, ylim=c( -3.2, 0 ) )
plotfxn( '~/figs/sfig7q.pdf', qsums['FP',,,,], log=T, ylim=c( -4.2, 0 ) )
rm( psums, qsums )
