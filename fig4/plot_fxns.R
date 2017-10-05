pointline	<- function(x, y, col, pch, lty, lwd=3.4, cex=2.3 ){
	points(x, y, col=col, pch=pch, cex=cex )
	lines( x, y, col=col, lty=lty, lwd=lwd )
}

panelfxn	<- function( y, ylim, add.yax, logy, TP=F, ... ){

	plot( 0:1, ylim, type='n', axes=F, xlab='', ylab='', ... )
	box()

	xlabs	<- round( 0:5/5, 2 )
	axis( 1, cex.axis=1.5, at=xlabs, lab=xlabs )

	mtext( side=1, expression( rho^2 ), line=4.5, cex=1.7 )
	if( add.yax )
		if( logy ){
			ylabs	<- round( 10^seq(log10(.01),0,len=5), 2 )
			axis( 2, cex.axis=1.5, at=log10( ylabs ), lab=ylabs )
		} else {
			axis( 2, cex.axis=1.5 )
		}

	fac	<- 'suporacle'
		pointline(rho2s, y[,1,fac], col=cols[fac], pch=16, lty=1 )
	if( TP )
		pointline(rho2s, y[,2,fac], col=cols[fac], pch=1, lty=2 )
	for( i in 1:2 )
		for( fac in c( 'pca', 'peer', 'sva', 'smartsva', 'ice' ) )
			pointline(rho2s, y[,i,fac], col=cols[fac], pch=c(1,16)[i]	, lty=3-i )
	i		<- 1
	fac	<- 'dummy'
			pointline(rho2s, y[,i,fac], col=cols[fac], pch=16					, lty=1 )
}

plotfxn	<- function( pdfname, y, log=F, ylab='False Positive Rate', types=c( 'base', 'hiu' ), ylim=c( 0, 1 ) ){

	pdf( pdfname, width=10, height=5 )
	layout( matrix( 1:4, 1, 4 ), widths=c(1.2,6,6,1.8) )
	par( mar=c( 6.5, 0, 5, 0 ) )
	
	plot.new()
	mtext( side=2, line=-2, cex=1.7, ylab )

	for( type in types ){
		if( type == 'base' ){
			main	<- substitute( paste(  xx, sigma[u]^2 ), list( xx='Moderate ' ) )
		} else if( type == 'hiu' ){
			main	<- substitute( paste(  xx, sigma[u]^2 ), list( xx='Large ' ) )
		} else if( type == 'dense,hix' ){
			main	<- substitute( paste(  xx, sigma[x]^2 ), list( xx='Dense and Large ' ) )
		} else if( type == 'hix1' ){
			main	<- substitute( paste(  xx, sigma[x]^2 ), list( xx='Large ' ) )
		} else {
			stop()
		}
		panelfxn( y[type,,,], add.yax=(type=='base'), ylim=ylim, logy=log, main=main, cex.main=3, TP=(ylab=='True Positive Rate') )
	}

	par( mar=c( 6.5, 0, 5, 0 ) )
	plot.new()
	legend( 'topleft'			, cex=1.2, leg=c('PCA','PEER','SVA','SmartSVA','Unsup','Sup'), col=c( cols[c('pca','peer','sva','smartsva')], 1, 1 ), lty=c(rep(NA,4),2,1), pch=c(rep(15,4),1,16), pt.cex=c(2,2,2,2,1,1), bty='n')
	if( ylab=='True Positive Rate' ){
		legend( 'bottomleft', cex=1.2, leg=c('None','Oracle','Oracle+','ICE (REML)','ICE (ML)'), lty=c(1,2,1,2,1)	, pch=c(16,1,16,1,16)	, col=c(1,6,6,'orange','orange'), bty='n' )
	} else {
		legend( 'bottomleft', cex=1.2, leg=c('None','Oracle'					,'ICE (REML)','ICE (ML)'), lty=c(1,1,2,1)		, pch=c(16,16,1,16)		, col=c(1,6,	'orange','orange'), bty='n' )
	}
	dev.off()
}
