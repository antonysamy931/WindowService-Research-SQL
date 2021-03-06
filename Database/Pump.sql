USE [master]
GO
/****** Object:  Database [Pump]    Script Date: 09/21/2016 18:31:43 ******/
CREATE DATABASE [Pump] ON  PRIMARY 
( NAME = N'Pump', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\Pump.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Pump_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\Pump_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Pump] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Pump].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Pump] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [Pump] SET ANSI_NULLS OFF
GO
ALTER DATABASE [Pump] SET ANSI_PADDING OFF
GO
ALTER DATABASE [Pump] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [Pump] SET ARITHABORT OFF
GO
ALTER DATABASE [Pump] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [Pump] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [Pump] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [Pump] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [Pump] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [Pump] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [Pump] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [Pump] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [Pump] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [Pump] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [Pump] SET  DISABLE_BROKER
GO
ALTER DATABASE [Pump] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [Pump] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [Pump] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [Pump] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [Pump] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [Pump] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [Pump] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [Pump] SET  READ_WRITE
GO
ALTER DATABASE [Pump] SET RECOVERY SIMPLE
GO
ALTER DATABASE [Pump] SET  MULTI_USER
GO
ALTER DATABASE [Pump] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [Pump] SET DB_CHAINING OFF
GO
USE [Pump]
GO
/****** Object:  Table [dbo].[Pump_Tb]    Script Date: 09/21/2016 18:31:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pump_Tb](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BrokerId] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Pump_Tb] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PendingQueue]    Script Date: 09/21/2016 18:31:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PendingQueue](
	[DueTime] [datetime2](7) NOT NULL,
	[BrokerMessageId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[EnqueuePending]    Script Date: 09/21/2016 18:31:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[EnqueuePending]
  @dueTime datetime2,
  @brokerMessageId uniqueidentifier
as
  set nocount on;
  insert into PendingQueue (DueTime, BrokerMessageId)
    values (@dueTime, @brokerMessageId);
GO
/****** Object:  StoredProcedure [dbo].[DequeuePending]    Script Date: 09/21/2016 18:31:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DequeuePending]
@NextId uniqueidentifier out
as
  set nocount on;
  declare @idTable table ( NextId uniqueidentifier )
  declare @now datetime2;
  set @now = getutcdate();
  with cte as (
    select top(1) 
      BrokerMessageId
    from PendingQueue with (rowlock, readpast)
    where DueTime < @now
    order by DueTime)
  delete from cte
    output deleted.BrokerMessageId into @idTable;
  set @NextId = (SELECT TOP(1) NextId FROM @idTable);
GO
