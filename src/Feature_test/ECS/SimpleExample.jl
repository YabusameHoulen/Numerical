# --- Components ---
# 组件是纯数据结构

mutable struct Position
    x::Float64
    y::Float64
end

mutable struct Velocity
    vx::Float64
    vy::Float64
end

# --- Entity ---
# 在这个简单示例中，我们用整数作为实体ID
const Entity = Int

# --- Storage ---
# 我们需要地方来存储每个实体的组件
# 使用字典将 Entity ID 映射到 Component 实例
const positions = Dict{Entity, Position}()
const velocities = Dict{Entity, Velocity}()

# --- System ---
# 系统包含操作组件数据的逻辑

function movement_system(dt::Float64)
    # 遍历所有 *同时* 拥有 Position 和 Velocity 组件的实体
    # intersect(keys(positions), keys(velocities)) 找到这些实体的 ID
    for entity_id in intersect(keys(positions), keys(velocities))
        pos = positions[entity_id]
        vel = velocities[entity_id]

        # 更新位置： pos = pos + vel * dt
        pos.x += vel.vx * dt
        pos.y += vel.vy * dt
    end
end

# --- 创建实体和添加组件 ---

# 创建实体 1 (有位置和速度)
entity1::Entity = 1
positions[entity1] = Position(0.0, 0.0)
velocities[entity1] = Velocity(1.0, 2.0)

# 创建实体 2 (只有位置)
entity2::Entity = 2
positions[entity2] = Position(10.0, 10.0)

# 创建实体 3 (有位置和速度)
entity3::Entity = 3
positions[entity3] = Position(5.0, 5.0)
velocities[entity3] = Velocity(-1.0, 0.0)

# --- 运行系统 ---

println("Initial state:")
for id in keys(positions)
    print("Entity $id: Position=$(positions[id])")
    if haskey(velocities, id)
        print(", Velocity=$(velocities[id])")
    end
    println()
end

# 模拟一小段时间
dt = 0.5
movement_system(dt)

println("\nAfter movement_system (dt = $dt):")
for id in keys(positions)
     print("Entity $id: Position=$(positions[id])")
    if haskey(velocities, id)
        print(", Velocity=$(velocities[id])")
    end
    println()
end

# 再次运行
movement_system(dt)

println("\nAfter another movement_system (dt = $dt):")
for id in keys(positions)
     print("Entity $id: Position=$(positions[id])")
    if haskey(velocities, id)
        print(", Velocity=$(velocities[id])")
    end
    println()
end