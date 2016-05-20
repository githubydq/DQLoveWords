//
//  DQCoreBloothViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/5/18.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQCoreBloothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "DQCoreBloothTableViewCell.h"

static NSString * const kServiceUUID = @"C5AC0853-5122-4856-AC70-A80E990D1C15";
static NSString * const kCharacteristicUUID = @"013AFE01-3E37-4E58-B6FD-DC4E67CF8F03";
//上面的数字是在Mac上用uuidgen命令生成的。

@interface DQCoreBloothViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)CBCentralManager * central;/**<中心*/
@property(nonatomic,strong)CBPeripheral * peripheral;/**<外设*/
@property(nonatomic,strong)NSMutableArray * peripheralArray;/**<外设数组*/
@property(nonatomic, strong)CBCharacteristic*characteristic;/**<特征*/


@property (weak, nonatomic) IBOutlet UITableView *table;
@end

static NSString * const identify1 = @"DQCoreBloothTableViewCell";

@implementation DQCoreBloothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self startCentral];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//懒加载重写getter方法
- (NSMutableArray *)peripheralArray
{
    if(!_peripheralArray) {
        _peripheralArray= [NSMutableArray array];
    }
    return _peripheralArray;
}

#pragma mark -
#pragma mark config UI
-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.table registerNib:[UINib nibWithNibName:@"DQCoreBloothTableViewCell" bundle:nil] forCellReuseIdentifier:identify1];
    
    self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.central.delegate = self;
    self.peripheralArray = [NSMutableArray new];
}

#pragma mark -
#pragma mark 中心
-(void)startCentral{
    //扫描周围蓝牙
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
//    [self.central scanForPeripheralsWithServices:nil options:dic];
    if (self.central) {
        
    }
    //连接一个蓝牙
//    [self.central connectPeripheral:self.peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}
#pragma mark -
#pragma mark 中心代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
//    [self.central scanForPeripheralsWithServices:nil options:nil];
    NSLog(@"%s",__FUNCTION__);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self.central scanForPeripheralsWithServices:nil options:dic];
            break;
        default:
            NSLog(@"Bluetooth is not working on the right state");
            break;
    }
}
//发现外设
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"Discovered %@", peripheral.name);
    [self.peripheralArray addObject:peripheral];
    if (self.peripheral != peripheral) {
        self.peripheral = peripheral;
        [self.central connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
        peripheral.delegate = self; // 处理peripheral的事件
    }
}
//已经连上外设
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    //因为在后面我们要从外设蓝牙那边再获取一些信息，并与之通讯，这些过程会有一些事件可能要处理，所以要给这个外设设置代理，比如：
//    peripheral.delegate = self;
    //查询蓝牙服务
    [peripheral discoverServices:nil];
}
//外设连接失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"%s",__FUNCTION__);
}
//已经断开外设连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark -
#pragma mark 外设代理
//外设发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //如果服务错误，返回
    if (error) {
        NSLog(@"error in discovering serviecs: %@", [error localizedDescription]);
        return;
    }
    for (CBService * service in peripheral.services){
        //查询服务所带的特征值
        [peripheral discoverCharacteristics:nil forService:service];
        //打印服务的UUID<c5ac0853 51224856 ac70a80e 990d1c15>
        NSLog(@"service's uuid : %@", service.UUID);
    }
}
//返回的蓝牙特征值通知通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            //            NSLog(@"characteristic uuid: %@", [characteristic UUID]);
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];//订阅特征
            }
        }
    }
//    for (CBCharacteristic * characteristic in service.characteristics) {
        //给蓝牙发数据
//        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//    }
}
//处理蓝牙发过来的数据
//上面setNotifyValue:YES函数设置了notify。那么这个特征值有更新的话，就会通过下面的函数告诉central
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"error notifying : %@", [error localizedDescription]);
        return;
    }
}

//peripheral读到数据,通过下面的代理方法获取value：
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"error notifying : %@", [error localizedDescription]);
        return;
    }
}

//
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

#pragma mark -
#pragma mark table delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.peripheralArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DQCoreBloothTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify1 forIndexPath:indexPath];
        cell.textLabel.text = @"蓝牙";
        cell.mySwitch.on = NO;
        return cell;
    }else{
        static NSString * identify2 = @"peripheralcell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        if (self.peripheralArray.count) {
            CBPeripheral *peripheral =self.peripheralArray[indexPath.row];
            cell.textLabel.text = peripheral.name;
        }
        return cell;
    }
}

@end
