rm( list=ls() )
load( 'Rdata/pars.Rdata' )
source( '../fig4/plot_fxns.R' )

factypes		<- c( 'dummy'	, 'pca', 'peer', 'sva', 'smartsva', 'suporacle', 'ice' )
lfactypes		<- c( 'None'	, 'PCA', 'PEER', 'SVA', 'SmartSVA', 'Oracle'		,'ICE' )
cols				<- c( 1:6, 'orange' )
names(cols)	<- factypes

panelfxn	<- function( y, ylim, add.yax, logy, ... ){

	y				<- y			[-length(sig2_us),,]
	sig2_us	<- sig2_us[-length(sig2_us)]

	y[,1,'smartsva']	<- NA

	plot( 0:1, ylim, type='n', axes=F, xlab='', ylab='', ... )
	box()
	axis( 1, cex.axis=1.5, at=0:5/5, lab=c( '0', '0.2', '0.4', '0.6', '0.8', '1' ) )
	mtext( side=1, expression( sigma[u]^2 ), line=4.5, cex=1.7 )
	if( add.yax )
		if( logy ){
			ylabs	<- round( 10^seq(log10(tol),0,len=5), 2 )
			axis( 2, cex.axis=1.5, at=log10( ylabs ), lab=ylabs )
		} else {
			axis( 2, cex.axis=1.5, at=0:5/5, lab=c( '0', '0.2', '0.4', '0.6', '0.8', '1' ) )
		}

	for( i in 2:1 )
		for( fac in c( 'pca', 'peer', 'sva', 'smartsva', 'oracle' ) )
			pointline(sig2_us, y[,i,fac], col=cols[fac], pch=c(1,16)[i]	, lty=c(2,1)[i] )
	fac	<- 'dummy'
			pointline(sig2_us, y[,1,fac], col=cols[fac], pch=16	, lty=1 )
}

plotfxn	<- function( pdfname, y, log=F, ylab='False Positive Replication Rate', ylim=c( 0, 1 ) ){

	types	<- c( 'base', 'hix'	,'hix,lro', 'dense,hix')

	npan	<- length( types )
	pdf( pdfname, width=3+3.5*npan, height=4.5 )
	layout( matrix( 1:(2+npan), 1, 2+npan ), widths=c(1.4,rep(6,npan),1.9) )
	par( mar=c( 6.5, 0, 5, 0 ) )
	
	if( log ){
		y			<- log10( y )
		ylim	<- c( log10( tol )-.2, 0 )
	}

	plot.new()
	mtext( side=2, line=-2, cex=1.8, ylab )

	for( type in types ){
		if( type == 'base' ){
			main	<- substitute( paste( xx ), list( xx='Baseline' ) )
		} else if( type == 'hix' ){
			main	<- substitute( paste(  xx, sigma[x]^2 ), list( xx='Large ' ) )
		} else if( type == 'hix,lro' ){
			main	<- substitute( paste(  xx, sigma[x]^2, yy, rho^2==0 ), list( xx='Large ', yy=', ' ) )
		} else if( type == 'dense,hix' ){
			main	<- substitute( paste(  xx, sigma[x]^2 ), list( xx='Dense and Large ' ) )
		} else {
			stop()
		}
		panelfxn( y[type,,,], add.yax=(type=='base'), ylim=ylim, logy=log, main=main, cex.main=3 )
	}


	par( mar=c( 6.5, 0, 5, 0 ) )
	plot.new()
	legend( 'topleft'			, cex=1.2, leg=c('PCA','PEER','SVA','SmartSVA','Unsup','Sup'), col=c( cols[c('pca','peer','sva','smartsva')], 1, 1 ), lty=c(rep(NA,4),2,1), pch=c(rep(15,4),1,16), pt.cex=c(2,2,2,2,1,1), bty='n')
	if( ylab=='True Positive Rate' ){
		legend( 'bottomleft', cex=1.2, leg=c('None','Oracle','Oracle+'                        ), lty=c(1,2,1,2,1)	, pch=c(16,1,16,1,16)	, col=c(1,6,6,'orange','orange'), bty='n' )
	} else {
		legend( 'bottomleft', cex=1.2, leg=c('None','Oracle'					                        ), lty=c(1,1,2,1)		, pch=c(16,16,1,16)		, col=c(1,6,	'orange','orange'), bty='n' )
	}

	dev.off()
}


dat_type	<- 'real'
tol				<- .01
load( paste0( 'Rdata/psums_', tol, '.Rdata' ) )
for( type in types )try({
	print( type )
	print( nruns[type,dat_type,,] )
})

plotfxn( '~/figs/fig5.pdf'	, psums['FP',,dat_type,,,] )
plotfxn( '~/figs/fig5log.pdf', psums['FP',,dat_type,,,],  log=T )
plotfxn( '~/figs/sfig12.pdf', qsums['FP',,dat_type,,,] )
plotfxn( '~/figs/sfig13.pdf', qsums['TP',,dat_type,,,], ylab='True Positive Replication Rate' )
rm( psums, qsums )

# p = .001
load( paste0( 'Rdata/psums_', .001, '.Rdata' ) )
plotfxn( '~/figs/sfig14.pdf', psums['FP',,dat_type,,,],  log=T )
rm( psums, qsums )

# p = .05
load( paste0( 'Rdata/psums_', .05, '.Rdata' ) )
plotfxn( '~/figs/sfig14a.pdf', psums['FP',,dat_type,,,] )
rm( psums, qsums )
